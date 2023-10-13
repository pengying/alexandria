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

// TODO(Peng): Tweak prompts over time
const systemTemplate = `
  You are a kids book author.   Your user will give you ideas for books that you'll then write.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  
  
  You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  
  
  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  
  
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

const userTemplate = `
Write \${prompt} for a \${age} year old named \${name}.
`;

const editorTemplate = `
You are a kids book editor that checks if a story is coherent and appropriate.  If it isn't, you modify the story to improve it's coherency.

The user will provide a story in json format and you will out put in json.
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
  const systemPrompt = populatePromptTemplate(systemTemplate, prompt).trim();
  const userPrompt = populatePromptTemplate(userTemplate, prompt).trim();
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

  return _promptHelper(editorTemplate.trim(), userPrompt);
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
