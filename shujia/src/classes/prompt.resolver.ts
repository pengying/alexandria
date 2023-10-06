import {
  Arg,
  FieldResolver,
  Int,
  Mutation,
  Query,
  Resolver,
  type ResolverInterface,
  Root,
  Ctx,
  InputType,
  Field,
} from "type-graphql";
import { Book } from "@generated/type-graphql";
import { Context } from "../context";
import { OpenAIConnector } from "./openai-connector";
import { PromptInput } from "./prompt.input";

@Resolver()
export class PromptResolver {
  private openAI = new OpenAIConnector();

  @Mutation(_returns => String)
  async generateBookFromPrompt(
    @Arg("prompt") prompt: PromptInput,
    @Ctx() ctx: Context
  ): Promise<String> {
    let book = await this.openAI.getBook(prompt);

    console.log(book);


    return JSON.stringify(book);
  }
}
