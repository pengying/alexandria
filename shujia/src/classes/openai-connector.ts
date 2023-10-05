import { OpenAI } from "langchain/llms/openai";
import { PromptInput } from "./prompt.input";

export class OpenAIConnector {

    getBook(prompt: PromptInput): string {
        return `${prompt.name}`;
    }
}