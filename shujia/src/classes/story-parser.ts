import { RegexParserFields } from './../../node_modules/langchain/dist/output_parsers/regex.d';
import { PrismaClient, Prisma } from '@prisma/client';
import {Logger} from 'tslog';

const logger = new Logger({name: "Story Parser"});
let story = {
    text: "Title: Jackie's Underwater Adventure\n" +
      '\n' +
      'Once upon a time, in a land not too far,\n' +
      'Lived a little girl named Jackie, a shining star.\n' +
      'With curiosity in her eyes, she loved to explore,\n' +
      'And today, she set off for the ocean floor.\n' +
      '\n' +
      'With her snorkel and fins, she dove into the sea,\n' +
      'Excitement bubbling inside, as happy as can be.\n' +
      'Down she went, deeper and deeper she swam,\n' +
      'Discovering wonders, like a true little clam.\n' +
      '\n' +
      '=====\n' +
      '\n' +
      'Page 1:\n' +
      'As Jackie descended, the water turned blue,\n' +
      'She marveled at the fish, in every shape and hue.\n' +
      'She saw a school of clownfish, swimming in a line,\n' +
      'And a graceful sea turtle, so majestic and fine.\n' +
      '\n' +
      'Page 2:\n' +
      'She spotted a coral reef, vibrant and bright,\n' +
      'With colorful creatures, a true underwater sight.\n' +
      'She learned that corals are animals, not plants,\n' +
      'And they build homes for many sea creatures, like ants.\n' +
      '\n' +
      'Page 3:\n' +
      'Deeper still, Jackie ventured, with a sense of awe,\n' +
      'She encountered a giant squid, with tentacles so raw.\n' +
      'She learned that squids are clever, with brains so smart,\n' +
      'And they can change colors, like a work of art.\n' +
      '\n' +
      'Page 4:\n' +
      'In the distance, she saw a mysterious shadow,\n' +
      'It was a humpback whale, putting on a show.\n' +
      'She learned that whales are gentle giants of the sea,\n' +
      'And they sing beautiful songs, so happy and free.\n' +
      '\n' +
      'Page 5:\n' +
      'As Jackie began her ascent, back to the surface above,\n' +
      'She felt grateful for the ocean, a world she came to love.\n' +
      'She realized the importance of protecting this place,\n' +
      'So future generations can explore with a smile on their face.\n' +
      '\n' +
      '=====\n' +
      '\n' +
      'And so, Jackie emerged from the ocean blue,\n' +
      'With stories to share, and lessons anew.\n' +
      'She knew that the ocean was a treasure to keep,\n' +
      'And she promised to protect it, even in her sleep.\n' +
      '\n' +
      'Character Appearance:\n' +
      'Jackie had curly brown hair and bright blue eyes,\n' +
      'With a smile that could light up the skies.\n' +
      'She wore a pink swimsuit, ready for adventure,\n' +
      'And her face was always filled with pure joy and pleasure.',
    totalCompletionTokens: 444,
    totalPromptTokens: 147,
    executionTokens: 591,
    id: ''
  };



const titleRe = new RegExp("Title:\\s(.+)\\n");
let title: String;

if(story.text.match(titleRe)) {
    title = story.text.match(titleRe)![1]; 
} else {
    Logger
    throw new Error("Couldn't parse title");
}


let book: Prisma.BookCreateInput;

book =  {
    title: 'test'
    
};

