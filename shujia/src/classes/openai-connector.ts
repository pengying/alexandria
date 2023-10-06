import { ChatOpenAI } from "langchain/chat_models/openai";
import { ChatPromptTemplate } from "langchain/prompts";
import { LLMChain } from "langchain/chains";

import { PromptInput } from "./prompt.input";
import { Logger } from "tslog";


let totalCompletionTokens = 0;
let totalPromptTokens = 0;
let totalExecutionTokens = 0;
let id: String = "";


const logger = new Logger({name:"LangChain"});

const chat = new ChatOpenAI({
  temperature: 0.1,
  modelName: "gpt-3.5-turbo",
  callbacks: [
    {
        handleLLMEnd(output, runId, parentRunId, tags) {
            const { completionTokens, promptTokens, totalTokens } = output.llmOutput?.tokenUsage;
            totalCompletionTokens = completionTokens ?? 0;
            totalPromptTokens = promptTokens ?? 0;
            totalExecutionTokens = totalTokens ?? 0;
            id = runId;
            logger.info(`Tokens: ${JSON.stringify(output.llmOutput?.tokenUsage)}`);
        },
    }
  ]
});

const systemTemplate = `
  You are a kids book author.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  You are inspired by authors like Dr. Seuss and Mo Willems.  Your books sometimes include life lessons.  Your user will give you ideas for books that you'll then write.  
  
  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  Break the book into pages delimited by =====.  Add a section ad the end to describe the characters appearance in simple terms.
  `;

const humanTemplate = `
Write {prompt} for a {age} year old named {name}.
`;

export class OpenAIConnector {
  async getBook(prompt: PromptInput): Promise<Record<string, any>>{
    const chatPrompt = ChatPromptTemplate.fromMessages([
      ["system", systemTemplate],
      ["human", humanTemplate],
    ]);

    const chain = new LLMChain({
      llm: chat,
      prompt: chatPrompt,
    });

    let result = await chain.call({
      prompt: prompt.prompt,
      name: prompt.name,
      age: prompt.age,
    });
    result.totalCompletionTokens = totalCompletionTokens;
    result.totalPromptTokens = totalPromptTokens;
    result.executionTokens = totalExecutionTokens;
    result.id = id;

    console.log({ result });;
    return result;
  }
}
