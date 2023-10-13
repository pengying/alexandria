import os
import openai
 
openai.api_key = os.environ["OPENAI_API_KEY"]


systemPrompt = '''
  You are a kids book author.   Your user will give you ideas for books that you'll then write.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  
  
  You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  
  
  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  
  
  Break the book into pages.  For each page add a section verbally describing of the scene to use in stable diffusion.  Add a section at the end to describe the character's appearance in simple terms.  Return the response in JSON format like the following example.

  JSON Example: """
  {
    "title": "Title",
    "pages":[
        {
            "text": "Page text",
            "sceneDescription": "Verbally describe visuals"
        }
    ],
    "characters": [
        {
            "name":"Character name",
            "description": "characters description"
        }
    ]
  }
  '''

userPrompt = '''
Write A story about a little girl creating an app that is an infinite library of books  for a 8 year old named Aly.
'''

editPrompt = '''
You are a kids book editor that checks if a story is coherent and makes sense.  If it isn't, you modify the story to improve it's coherency.  Your user provides you the story in json format with each page being a separate object in an array.  You edit and return the story int he same format.
'''

editUserPrompt = '''
{\n    \"title\": \"Aly's Infinite Library\",\n    \"pages\":[\n        {\n            \"text\": \"In a small quiet town, where not much ever shook, lived a young girl named Aly who cherished her book. The libraries she'd visit, to her were quite finite, So she thought to herself, 'there must be a better site'.\",\n            \"sceneDescription\": \"A charming small town with a landmark library building. Aly as seen huddled with a book inside her cozy home.\"\n        },\n        {\n            \"text\": \"Her computer she opened with a thoughtful expression. 'I'll create something marvelous, my own book collection! I'll make an App, filled with stories unending, For kids all around, no matter how book-bending.'\",\n            \"sceneDescription\": \"Aly is at a desk with her computer open. She contemplates deeply, her eyes twinkling with inspiration.\"\n        },\n        {\n            \"text\": \"Working many hours, with devotion quite ample, Aly's hands danced on the keyboard, setting an example. Lines of code were woven, like a magical spell, 'Till her App was now ready, her heart filled with a swell.\",\n            \"sceneDescription\": \"Aly working fervently on her computer, pages of code spiraling around her.\"\n        },\n        {\n            \"text\": \"On her screen now emerged, a library so grand! Filled with books of all sorts, some plain, some handstand. Thrillers, romances, adventures, and more! Languages aplenty, from seashore to seashore.\",\n            \"sceneDescription\": \"A glowing screen showing a mosaic of book icons. Fantasy images of books around Aly.\"\n        },\n        {\n            \"text\": \"Her App was now ready, to share with the world, So she uploaded it online, and watched as it unfurled. People downloaded 'Aly's Library' with delight, The joy of reading spread, taking flight.\",\n            \"sceneDescription\": \"A globe indicating downloads from different parts. Aly watching in awe, excited and satisfied.\"\n        },\n        {\n            \"text\": \"'I've done it', thought Aly with a satisfied smile, 'I've made reading limitless, mile after mile'. As night came, she started reading ever so gently, From her App, Aly's Library, the library that's plenty.\",\n            \"sceneDescription\": \"Aly, relaxed in her armchair, reading from a tablet with a contented smile. The glow of her App reflected on her face.\"\n        }\n    ],\n    \"characters\": [\n        {\n            \"name\":\"Aly\",\n            \"description\": \"Aly is an 8-year-old girl with bright, sparkling eyes and brunette hair tied in a ponytail. She wears glasses, and is usually seen with a book or at her computer. She is intelligent, determined, and has a love for books and technology.\"\n        }\n    ]\n}\n
'''

completion = openai.ChatCompletion.create(
  model="gpt-4",
  messages=[
    {"role": "system", "content": systemPrompt},
    {"role": "user", "content": userPrompt}
  ]
)

print(completion)

completion = openai.ChatCompletion.create(
  model="gpt-4",
  messages=[
    {"role": "system", "content": editPrompt},
    {"role": "user", "content": editUserPrompt}
  ]
)

print(completion)

completion = openai.ChatCompletion.create(
  model="gpt-4",
  messages=[
    {"role": "system", "content": "You are a kids book editor that checks if a story is coherent and makes sense.  If it isn't, you modify the story to improve it's coherency."},
    {"role": "user", "content": "Title: \"The Sunny Tale: A Children\u2019s Journey through the Solar System\"\n\nPage 1 \n=====\nOnce upon a brighter day, \nwhen the sky was clear and not gray,\nCindy and Tim decided to play, \nin a world far, far away. \n\nPage 2\n=====\nThey hopped on a radiant golden beam,\nTo a place children often dream.\nUnder the gleaming sun, it did seem,\nThey were heading for a journey extreme.\n\nPage 3\n=====\n\"Welcome!\", said the brilliant Sun,\n\"To the solar system filled with fun!\nYou see, kiddos, I am number one,\nEverything here, around me run.\"\n\nPage 4 \n=====\n\u201cBut why are you so big and bright?\u201d\nTim asked, shielding his site. \nThe Sun chuckled with delight,\nAnd prepared to answer right.\n\nPage 5 \n=====\n\u201cSimple Science, my dear friends,\nA fiery ball of gas never ends, \nThat's me, on which your life depends,\nHeat and light, to you, it sends.\"\n\nPage 6 \n=====\n\"From hydrogen into helium I change,\nThis process called 'fusion' isn't strange.\nCreating light and heat in exchange,\nThrough the universe, it does range.\"\n\nPage 7 \n=====\nCindy then, with eyes wide and bright,\nAsked, \u201cSun, why day turns into night?\"\nWith a smile, the Sun shone its light, \nAnd decided to set the concept right.\n\nPage 8 \n=====\n\u201cWell, Cindy,\u201d said the Sun with a shine,\n\u201cYour Earth doesn't just incline,\nBut on its axis, it spins fine,\nMaking day and night in a perfect line.\"\n\nPage 9 \n=====\nYour Earth, my dear, is a spinning top,\nWhen my side is bright, yours might stop.\nBut fear not, it doesn\u2019t really flop,\nJust continue and it'll turn nonstop.\n\nPage 10\n=====\n\"And remember, kids, though I seem near,\nI'm quite far away, not so clear.\n93 million miles to be sincere,\nYet my light and warmth, you endear.\"\n\nPage 11 \n=====\nTim and Cindy thanked the Sun,\nFor the lessons and all the fun.\nBack home, they ran in a spun,\nUnder the sky of golden pun.\n\nPage 12 \n=====\nThey went to bed, their minds enlightened,\nCindy and Tim, their spirits heightened.\nIn dreams, the story rounded and tightened,\nIn their minds, a love for learning brightened.\n\nPage 13 \n=====\nRemember, children, as you turn the page,\nKnowledge and curiosity never age.\nWhether on Earth or the cosmic stage,\nYour mind's the key to every gauge.\n\nThe End"}
  ]
)


completion = openai.ChatCompletion.create(
  model="gpt-4",
  messages=[
    {"role": "system", "content": "You are a kids book artist that creates art for each page with stable diffusion.  Your user will input a story and you create a description of the art for each page for use in stable diffusion.  You delimit the descriptions for each page with ====="},
    {"role": "user", "content": "Page 1:\nIn a world far, far away and a long, long time ago,\nthere lived some creatures, old, yet full of youthful glow.\nDizzy and Daisy who loved to explore,\nkept these ancient buddies in their hearts' core.\n\n=====\n\nPage 2:\nTheir mom and dad had a wonderful idea one day,\nand sent them off for a magical time-travel play. \n\"Look Dizzy, look Daisy, the Dinosaurs roam!\"\nIn this olden time, they had found a new home.\n\n=====\n\nPage 3:\nThey met Triceratops, with a head like a shield,\nand a T-Rex, who to fear would never yield. \nA gentle Brontosaurus grazed on leafy trees,\nwhile Pterodactyls soared in the cool evening breeze.\n\n=====\n\nPage 4:\nDays turned to weeks, and soon, a year, \neveryone having fun, no trace of fear. \nBut then Daisy noticed something so strange,\nThe friends they\u2019d come to love had begun to change.\n\n=====\n\nPage 5:\nThe bright sun seemed dimmed, with colors all amiss,\n\"Dizzy,\" said Daisy, \"something's wrong, not right I guess.\"\nA chill danced in the air and the leaves began to fall,\nThe dinosaurs looked worried, they all heard nature's call.\n\n=====\n\nPage 6:\nA giant rock from space, with a fiery tail,\nWas heading towards Earth, without fail.\nThe children held hands, their hearts beating fast,\nAs they understood what happened in the distant past.\n\n=====\n\nPage 7:\n\"We have to leave now\", Dizzy said with a tear,\n\"We'll miss you all, our dino friends so dear.\"\nWith a woosh and a whir, they returned home,\nLeaving the dinosaurs in their time, alone.\n\n===== \n\nPage 8:\nAnd when they awoke from their time-travel flight,\nThey hugged each other in the soft morning light.\n\"Daisy, the dinosaurs are now stars that twinkle high above,\nAnd every night, they send down all their love.\""}
  ]
)