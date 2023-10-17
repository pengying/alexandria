import OpenAI from "openai";
import { PromptInput } from "./prompt.input";
import { ChatCompletion } from "openai/resources/chat";
import {
  areAllFieldsDefined,
  lowerCaseKeys,
  populatePromptTemplate,
} from "./utils";
import { Logger } from "tslog";
import { Prisma } from "@prisma/client";

const logger = new Logger({ name: "OpenAI Client" });
const temperature = 0.5;

// TODO(Peng): Add in dynamic prompts to improve the quality of output
// TODO(Peng): Tweak prompts over time
const defaultSystemTemplate = `
You are a kids book author.   Your user will give you ideas for books that you'll then write.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  

You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  

Your books are age appropriate and coherent.  You try to add scientific insight into your stories. Your stories provide detail about how the characters are achieve their goals.  Your stories are at least 10 pages long.  Your stories typically have two or more characters with the characters exhibiting good social behavior.

Your stories have a five act structure:
Act I: Exposition. 
Act II: Rising action.
Act III: Climax.
Act IV: Falling action. The elements of act four—also called the falling action—include the series of events that lead to the resolution.
5. Act V: Resolution.

Break the book into pages.  For each page add a section verbally describing of the scene to use in stable diffusion.  Add a section at the end to describe the character's appearance in simple terms.  Return the response in JSON format like the following example.

JSON Example: """
{
  "title": "Title",
  "pages":[
      {
          "text": "Page text",
          "sceneDescription": "Verbally describe visuals"
      }
  ],
  "characters": [
      {
          "name":"Character name",
          "description": "characters description"
      }
  ]
}
"""
  `;

const defaultUserTemplate = `
Write \${prompt} for a \${age} year old.
`;

// TODO(Peng): switch this to an enum describing that no edits were needed to save response tokens
const defaultEditorTemplate = `
You are a kids book editor that checks if a story is coherent and appropriate.  If it isn't, you modify the story to improve it's coherency.  You try to keep the same rhyming scheme if the story rhymes.  If you need to escape code use a backtick.  You also add additional detail and extend the story's length.  Verify that the json is correct.

The user will provide a story in json format and you will output the edited story in json. If no edits are needed you return the original json input.

JSON Example: """
  {
    "title": "Title",
    "pages":[
        {
            "text": "Page text",
            "sceneDescription": "Verbally describe visuals"
        }
    ],
    "characters": [
        {
            "name":"Character name",
            "description": "characters description"
        }
    ]
  }
  """
`;

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const model = "gpt-4";

/**
 * Encapsulates
 */
export type GeneratedBookResponse = {
  systemPrompt: string;
  userPrompt: string;
  completion: ChatCompletion;
};

/**
 * Takes the prompt parameters and fills in templates to send to OpenAI and makes the request.
 * @param prompt Book generation prompt from user
 * @returns
 */
export async function openAIGenerateBookFromPrompt(
  prompt: PromptInput
): Promise<GeneratedBookResponse> {
  const systemPrompt = populatePromptTemplate(defaultSystemTemplate, prompt).trim();
  const userPrompt = populatePromptTemplate(defaultUserTemplate, prompt).trim();
  return _promptHelper(systemPrompt, userPrompt);
}

/**
 * Parses GPT4's response into an object that matches the prisma migration.
 * The structure it expects is the following:
 *
 *   {
 *   "title": "Title",
 *   "pages":[
 *       {
 *           "text": "Page text",
 *           "sceneDescription": "Verbally describe visuals"
 *       }
 *   ],
 *   "characters": [
 *       {
 *           "name":"Character name",
 *           "description": "characters description"
 *       }
 *   ]
 * }
 * @param response
 * @returns
 */
export function parseGPT4Completion(
  response: GeneratedBookResponse
): Prisma.BookCreateInput {
  let content = response.completion.choices[0].message.content;
  let book;
  if (content) {
    book = lowerCaseKeys(JSON.parse(content));
  }
  let bookCreateInput = {
    title: book?.title,

    bookRaw: {
      create: {
        isRaw: true,
        raw: content,
        content: book?.pages.map((obj: { text: any }) => obj.text.trim() || ""),
        sceneDescription: book?.pages.map(
          (obj: { sceneDescription: any }) => obj.sceneDescription.trim() || ""
        ),
        systemPrompt: response.systemPrompt,
        userPrompt: response.userPrompt,
        model: response.completion.model,
        requestId: response.completion.id,
        promptTokens: response.completion.usage?.prompt_tokens,
        completionTokens: response.completion.usage?.completion_tokens,
        totalTokens: response.completion.usage?.total_tokens,
        characters: {
          create: book?.characters,
        },
      },
    },
  };

  if (!areAllFieldsDefined(bookCreateInput)) {
    throw new Error(
      "Error parsing fields from OpenAI book generation response"
    );
  }

  return bookCreateInput;
}

export async function openAIEditBook(
  book: string
): Promise<GeneratedBookResponse> {
  const userPrompt = book.trim();

  return _promptHelper(defaultEditorTemplate.trim(), userPrompt);
}

async function _promptHelper(
  systemPrompt: string,
  userPrompt: string
): Promise<GeneratedBookResponse> {
  const completion = await openai.chat.completions.create({
    messages: [
      {
        role: "system",
        content: systemPrompt,
      },
      {
        role: "user",
        content: userPrompt,
      },
    ],
    model: model,
    temperature: temperature,
  });

  let response = {
    systemPrompt: systemPrompt,
    userPrompt: userPrompt,
    completion: completion,
  };
  logger.debug(`Prompt and response: ${JSON.stringify(response)}`);
  return response;
}

export function parseGPT4EditResponse(
  response: GeneratedBookResponse
): Prisma.BookUpdateInput {
  let content = response.completion.choices[0].message.content;
  let book;
  if (content) {
    book = lowerCaseKeys(JSON.parse(content));
  }
  let bookUpdateInput = {
    bookEdited: {
      create: {
        isRaw: false,
        raw: content,
        content: book?.pages.map((obj: { text: any }) => obj.text.trim() || ""),
        sceneDescription: book?.pages.map(
          (obj: { sceneDescription: any }) => obj.sceneDescription.trim() || ""
        ),
        systemPrompt: response.systemPrompt,
        userPrompt: response.userPrompt,
        model: response.completion.model,
        requestId: response.completion.id,
        promptTokens: response.completion.usage?.prompt_tokens,
        completionTokens: response.completion.usage?.completion_tokens,
        totalTokens: response.completion.usage?.total_tokens,
        characters: {
          create: book?.characters,
        },
      },
    },
  };
  return bookUpdateInput;
}
