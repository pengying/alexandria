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

  @Mutation()
  generateBookFromPrompt(
    @Arg("data") prompt: PromptInput,
    @Ctx() ctx: Context
  ): Book {
    console.log(this.openAI.getBook(prompt));

    return new Book();
  }
}
