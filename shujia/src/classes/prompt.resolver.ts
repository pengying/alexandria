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
import {
  GeneratedBookResponse,
  openAIEditBook,
  openAIGenerateBookFromPrompt,
  parseGPT4Completion,
  parseGPT4EditResponse,
} from "./openai";
import { PromptInput } from "./prompt.input";
import { PrismaClient, Prisma } from "@prisma/client";

const story = {
  systemPrompt:
    "You are a kids book author.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  \n  \n  You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  \n  \n  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  \n  \n  Break the book into pages.  Add a section at the end to describe the character's appearance in simple terms.  Return the response in JSON format.\n\n  Your user will give you ideas for books that you'll then write.",
  userPrompt:
    "Write A story about learning how to swim for a 5 year old named jill.",
  completion: {
    id: "chatcmpl-86jHVCAl3YqxsZofBYwY3Mk2o6j5x",
    object: "chat.completion",
    created: 1696614721,
    model: "gpt-4-0613",
    choices: [
      {
        index: 0,
        message: {
          role: "assistant",
          content:
            '{\n  "title": "Jill Learns to Swim",\n  "pages": [\n    {\n      "page_number": 1,\n      "text": "Once upon a time, there was a girl named Jill, who lived by a peaceful, calm hill."\n    },\n    {\n      "page_number": 2,\n      "text": "She loved to run and play, but there was one thing that made her dismay."\n    },\n    {\n      "page_number": 3,\n      "text": "She was afraid of the water, it made her shiver, unlike her brother and sister."\n    },\n    {\n      "page_number": 4,\n      "text": "One sunny day, she decided to be brave, \'I will learn to swim, I will not cave.\'"\n    },\n    {\n      "page_number": 5,\n      "text": "She put on her swimsuit, with a little fright, but her heart was filled with light."\n    },\n    {\n      "page_number": 6,\n      "text": "With a deep breath, she stepped into the pool, feeling the water cool."\n    },\n    {\n      "page_number": 7,\n      "text": "She splashed and kicked, her fear started to fade, she was no longer afraid."\n    },\n    {\n      "page_number": 8,\n      "text": "She learned to float, she learned to glide, with every stroke, she felt pride."\n    },\n    {\n      "page_number": 9,\n      "text": "Jill was swimming, oh what a sight, her face was filled with delight."\n    },\n    {\n      "page_number": 10,\n      "text": "From that day on, Jill loved to swim, she learned a lesson, thanks to a whim."\n    }\n  ],\n  "characters": [\n    {\n      "name": "Jill",\n      "description": "Jill is a 5-year-old girl with bright, curious eyes and a heart full of courage. She has short, brown hair that she ties in a ponytail when she goes swimming. She wears a pink swimsuit with a picture of a dolphin on it. Jill is brave and loves to learn new things."\n    }\n  ],\n  "lesson": "The story teaches that overcoming fears can open up new experiences and joys. It encourages children to be brave and try new things."\n}',
        },
        finish_reason: "stop",
      },
    ],
    usage: { prompt_tokens: 153, completion_tokens: 498, total_tokens: 651 },
  },
} as GeneratedBookResponse;

const editedStory = {
  systemPrompt:
    "You are a kids book author.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  \n  \n  You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  \n  \n  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  \n  \n  Break the book into pages.  Add a section at the end to describe the character's appearance in simple terms.  Return the response in JSON format.\n\n  Your user will give you ideas for books that you'll then write.",
  userPrompt:
    "Write A story about learning how to swim for a 5 year old named jill.",
  completion: {
    id: "chatcmpl-89HMatJiuW2tnq6EE0jhcp15D90MW",
    object: "chat.completion",
    created: 1697222388,
    model: "gpt-4-0613",
    choices: [
      {
        index: 0,
        message: {
          role: "assistant",
          content:
            '{\n    "title": "Aly\'s Infinite Library",\n    "pages":[\n        {\n            "text": "In a small quiet town, where not much ever changes, lived a young girl named Aly, a reader of many ranges. Local libraries she\'d visit, each to her felt finite, So she thought to herself, \'I must find a new site\'.",\n            "sceneDescription": "Small town scenes with a beautiful library at its core. Aly is depicted reading a book in her warm, comfy home."\n        },\n        {\n            "text": "With a thoughtful look she opened her computer, \'I\'ll make something spectacular, a digital book tutor! I\'ll design an App, filled with infinite stories. It\'ll be a haven for young readers, no matter their worries.\'",\n            "sceneDescription": "Aly contemplating at her desk with her computer open. Her eyes are filled with inspiration and enthusiasm."\n        },\n        {\n            "text": "After hours of hard work, and relentless dedication, Aly\'s hands tap danced on the keys, with no hesitation. Lines of code were woven, like a magnificent spell, Until finally her App was ready, her heart filled with swell.",\n            "sceneDescription": "Aly meticulously working on her computer, bundles of code spiralling around her."\n        },\n        {\n            "text": "What emerged on her screen was grander than she planned! A virtual library filled with books of all sorts, from every land. Thrillers, romances, adventures, and more! Languages aplenty, from every shore.",\n            "sceneDescription": "A vibrant screen displaying a tapestry of book icons. Whimsical images of diverse books encircle Aly."\n        },\n        {\n            "text": "Her App was now ready to travel the world, So she published it online, and watched it unfurl. People downloaded \'Aly\'s Library\' with delight, The joy of reading was spreading, taking flight.",\n            "sceneDescription": "A world map showcasing download statistics from different parts of the globe. Aly watching eagerly, her face glowing with joy and satisfaction."\n        },\n        {\n            "text": "\'I\'ve done it\', reflected Aly with a satisfied grin, \'Reading is now limitless, let the adventures begin\'. As the night arrived, she began reading serenely, From \'Aly\'s Library\', the library that\'s infinitely dreamy.",\n            "sceneDescription": "A content Aly lounging in a chair, engrossed in her tablet. The soft glow of her App reflecting on her bespectacled face."\n        }\n    ],\n    "characters": [\n        {\n            "name":"Aly",\n            "description": "Aly is a spirited 8-year-old girl with bright, sparkling eyes and chestnut hair tied in a ponytail. She wears glasses and is often seen engrossed in a book or working on her computer. She is intelligent, determined, and has a unique fondness for books and technology."\n        }\n    ]\n}',
        },
        finish_reason: "stop",
      },
    ],
    usage: {
      prompt_tokens: 683,
      completion_tokens: 617,
      total_tokens: 1300,
    },
  },
} as GeneratedBookResponse;

const prisma = new PrismaClient();

@Resolver()
export class PromptResolver {
  //   private openAI = new OpenAIConnector();

  @Mutation((_returns) => Book)
  async generateBookFromPrompt(
    @Arg("prompt") prompt: PromptInput,
    @Ctx() ctx: Context
  ): Promise<Book | undefined> {
    // TODO(Peng): Handle errors eg LLM says "I can't assist with that"
    // TODO(Peng): Add better error handling
    let book: Prisma.BookCreateInput;
    let persistedBook: Book;
    let editedBook: Prisma.BookUpdateInput;
    let persistedEditedBook: Book;

    try {
      book = parseGPT4Completion(await openAIGenerateBookFromPrompt(prompt));
      // book = parseGPT4Completion(editedStory)
      persistedBook = await prisma.book.create({ data: book });

      if (book.bookRaw?.create?.raw) {
        editedBook = parseGPT4EditResponse(
          await openAIEditBook(book.bookRaw.create.raw)
        );
        // editedBook = parseGPT4EditResponse(editedStory);
        persistedEditedBook = await prisma.book.update({
          data: editedBook,
          where: {
            uuid: persistedBook.uuid,
          },
        });
        console.log(persistedEditedBook);
        return persistedEditedBook;
      } else {
        throw new Error("Could not parse book raw");
      }
    } catch (error) {
      console.log(error);
    }
  }
}
