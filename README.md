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

## Gcloud config

### Postgres
#### Enable APIs
```bash
gcloud services enable sqladmin.googleapis.com iam.googleapis.com
```
#### Create cloud instance
```bash
gcloud sql instances create alexandria-dev \
--database-version=POSTGRES_14 \
 --cpu=1 \
 --memory=4GB \
 --region=us-central \
 --root-password=$CLOUD_SQL_PW
 ```

```bash
gcloud sql databases create shujia-db --instance=alexandria-dev
gcloud sql users create shujia-user \
--instance=alexandria-dev \
--password=$CLOUD_SQL_USER_PW
```

```bash
gcloud iam service-accounts list
```

```bash
EMAIL=479569486913-compute@developer.gserviceaccount.com
gcloud projects add-iam-policy-binding silken-hulling-402322 \
  --member="serviceAccount:$EMAIL" \
  --role="roles/cloudsql.client"
```

```bash
PROJECT_ID=silken-hulling-402322
INSTANCE_CONNECTION_NAME=silken-hulling-402322:us-central1:quickstart-instance
gcloud run deploy run-sql --image gcr.io/$PROJECT_ID/run-sql \
  --add-cloudsql-instances silken-hulling-402322:us-central1:quickstart-instance \
  --set-env-vars INSTANCE_UNIX_SOCKET="/cloudsql/silken-hulling-402322:us-central1:quickstart-instance" \
  --set-env-vars INSTANCE_CONNECTION_NAME="silken-hulling-402322:us-central1:quickstart-instance" \
  --set-env-vars DB_NAME="quickstart-db" \
  --set-env-vars DB_USER="quickstart-user" \
  --set-env-vars DB_PASS=$CLOUD_SQL_USER_PW
```

#### Cloud auth proxy to run locally
```bash
curl -o cloud-sql-proxy \
https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.0.0/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy
```

```bash
gcloud iam service-accounts keys create KEY_FILE --iam-account=quickstart-service-account@PROJECT_ID.iam.gserviceaccount.com
```

```bash
./cloud-sql-proxy \
--credentials-file $GCLOUD_SQL_SERVICE_CREDENTIALS \
silken-hulling-402322:us-central1:alexandria-dev
```

#### Service account enable logging
```bash
gcloud projects add-iam-policy-binding silken-hulling-402322 \
  --member="serviceAccount:479569486913-compute@developer.gserviceaccount.com" \
  --role="roles/logging.logWriter"
```

## TODOs
- Move story generation to start with chapters -> fill in story
- 