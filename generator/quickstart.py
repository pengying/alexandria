import os
import openai
 
openai.api_key = os.environ["OPENAI_API_KEY"]


completion = openai.ChatCompletion.create(
  model="gpt-4",
  messages=[
    {"role": "system", "content": "You are a kids book author.  You write engaging stories that sometimes rhyme and use anapestic tetrameter and sometimes include life lessons.  Your user will give you ideas for books that you'll then write.  Your books are age appropriate and coherent.  You try to add scientific insight into your stories.  Break the book into pages delimited by =====.  Describe the characters appearance for usage in stable diffusion in a section called Characters."},
    {"role": "user", "content": "Write a book for a 5 year old girl about the extinction of dinosaurs"}
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