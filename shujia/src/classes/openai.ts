import OpenAI from "openai";
import { PromptInput } from "./prompt.input";
import { ChatCompletion } from "openai/resources/chat";
import { populatePromptTemplate } from "./utils";
import { Logger } from "tslog";
import { Prisma } from "@prisma/client";

const logger = new Logger({ name: "OpenAI Client" });

// TODO(Peng): Tweak prompts over time

const systemTemplate = `
  You are a kids book author.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  
  
  You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  
  
  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  
  
  Break the book into pages.  Add a section at the end to describe the character's appearance in simple terms.  Return the response in JSON format.

  Your user will give you ideas for books that you'll then write.  
  `;

const userTemplate = `
Write \${prompt} for a \${age} year old named \${name}.
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
    temperature: 0.5,
  });
  let response = {
    systemPrompt: systemPrompt,
    userPrompt: userPrompt,
    completion: completion,
  };
  logger.debug(`Prompt and response: ${JSON.stringify(response)}`);
  return response;
}

/**
 *
 * @param response
 * @returns
 */
export function parseGPT4Completion(
  response: GeneratedBookResponse
): Prisma.BookCreateInput {
  let content = response.completion.choices[0].message.content;
  let book;
  if (content) {
    book = JSON.parse(content);
  }
  
  return {
    title: book.title,
    bookRaw: {
      create: {
        isRaw: true,
        raw: content,
        content: book.pages.map((obj: { text: any }) => obj.text.trim() || ""),
        systemPrompt: response.systemPrompt,
        userPrompt: response.userPrompt,
        model: response.completion.model,
        requestId: response.completion.id,
        promptTokens: response.completion.usage?.prompt_tokens,
        completionTokens: response.completion.usage?.completion_tokens,
        totalTokens: response.completion.usage?.total_tokens,
      },
    },
  };
}
