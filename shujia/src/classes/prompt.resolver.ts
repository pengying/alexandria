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
  } from "type-graphql";
import { Book } from "@generated/type-graphql"
import { Context } from "../context"

  @Resolver()
  class PromptResolver {

    @Mutation()
    generateBookFromPrompt(@Ctx() ctx: Context): Book {
        return new Book();
    }
  }
