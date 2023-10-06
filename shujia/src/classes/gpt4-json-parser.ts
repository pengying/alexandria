import { RegexParserFields } from 'langchain/dist/output_parsers/regex';
import { PrismaClient, Prisma } from '@prisma/client';
import {Logger} from 'tslog';

const logger = new Logger({name: "Story Parser"});

let story = {"systemPrompt":"You are a kids book author.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  \n  \n  You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  \n  \n  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  \n  \n  Break the book into pages.  Add a section at the end to describe the character's appearance in simple terms.  Return the response in JSON format.\n\n  Your user will give you ideas for books that you'll then write.","userPrompt":"Write A story about learning how to swim for a 5 year old named jill.","completion":{"id":"chatcmpl-86jHVCAl3YqxsZofBYwY3Mk2o6j5x","object":"chat.completion","created":1696614721,"model":"gpt-4-0613","choices":[{"index":0,"message":{"role":"assistant","content":"{\n  \"title\": \"Jill Learns to Swim\",\n  \"pages\": [\n    {\n      \"page_number\": 1,\n      \"text\": \"Once upon a time, there was a girl named Jill, who lived by a peaceful, calm hill.\"\n    },\n    {\n      \"page_number\": 2,\n      \"text\": \"She loved to run and play, but there was one thing that made her dismay.\"\n    },\n    {\n      \"page_number\": 3,\n      \"text\": \"She was afraid of the water, it made her shiver, unlike her brother and sister.\"\n    },\n    {\n      \"page_number\": 4,\n      \"text\": \"One sunny day, she decided to be brave, 'I will learn to swim, I will not cave.'\"\n    },\n    {\n      \"page_number\": 5,\n      \"text\": \"She put on her swimsuit, with a little fright, but her heart was filled with light.\"\n    },\n    {\n      \"page_number\": 6,\n      \"text\": \"With a deep breath, she stepped into the pool, feeling the water cool.\"\n    },\n    {\n      \"page_number\": 7,\n      \"text\": \"She splashed and kicked, her fear started to fade, she was no longer afraid.\"\n    },\n    {\n      \"page_number\": 8,\n      \"text\": \"She learned to float, she learned to glide, with every stroke, she felt pride.\"\n    },\n    {\n      \"page_number\": 9,\n      \"text\": \"Jill was swimming, oh what a sight, her face was filled with delight.\"\n    },\n    {\n      \"page_number\": 10,\n      \"text\": \"From that day on, Jill loved to swim, she learned a lesson, thanks to a whim.\"\n    }\n  ],\n  \"characters\": [\n    {\n      \"name\": \"Jill\",\n      \"description\": \"Jill is a 5-year-old girl with bright, curious eyes and a heart full of courage. She has short, brown hair that she ties in a ponytail when she goes swimming. She wears a pink swimsuit with a picture of a dolphin on it. Jill is brave and loves to learn new things.\"\n    }\n  ],\n  \"lesson\": \"The story teaches that overcoming fears can open up new experiences and joys. It encourages children to be brave and try new things.\"\n}"},"finish_reason":"stop"}],"usage":{"prompt_tokens":153,"completion_tokens":498,"total_tokens":651}}};



const titleRe = new RegExp("Title:\\s(.+)\\n");
let title: String;

// if(story.text.match(titleRe)) {
//     title = story.text.match(titleRe)![1]; 
// } else {
//     logger.error("")
//     throw new Error("Couldn't parse title");
// }



let book: Prisma.BookCreateInput;

book =  {
    title: 'test'
    
};
