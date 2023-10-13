# Alexandria

## Steps to run

1. Set OpenAI API Key

OPENAI_API_KEY={API Key}

2. Run
```bash
docker compose up
```

docker compose up db

cp src/schema.graphql ../papillon/lib/



## Graphql examples
```
{
  "data": {
    "title": "title",
    "bookRaw": {
      "create": {
        "content": {
          "set": [
          "test1",
          "test2"
          ]
        },
        "isRaw": true,
        "model": "GPT-4",
        "promptTokens": 123,
      }
    },
    "characters": {
      "create": [{
            "name": "test1",
            "description": "black hair"
      },
      {
        "name": "character2",
        "description": "c2"
      }]
    }
  },
  "where": null
}
```

```
mutation Mutation($data: BookCreateInput!) {
  createOneBook(data: $data) {
    bookRaw {
      content
      model
      isRaw
      promptTokens
    }
    title
    characters {
      description
      name
    }
  }
}

query Books {
  books {
    title
    characters {
      name
      description
    }
    bookRaw {
      content
      model
      systemPrompt
      userPrompt
      requestId
      promptTokens
      completionTokens
      totalTokens
      raw
    }
  }
}
```