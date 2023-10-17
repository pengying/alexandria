import { Field, InputType, Int } from "type-graphql";

@InputType()
export class PromptInput {
  @Field()
  name: string;

  @Field((type) => Int)
  age: number;

  @Field()
  userPrompt: string;

  @Field()
  systemPrompt: string

  @Field()
  editPrompt: string
}
