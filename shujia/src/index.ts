import 'reflect-metadata'

import path from "node:path";

import { ApolloServer } from '@apollo/server'
import { startStandaloneServer } from '@apollo/server/standalone'
import { GraphQLScalarType } from 'graphql'
import { DateTimeResolver } from 'graphql-scalars'
import * as tq from 'type-graphql'
import { Context, context } from './context'
import { resolvers } from "@generated/type-graphql"


const app = async () => {
  // tq.registerEnumType(SortOrder, {
  //   name: 'SortOrder',
  // })

  const schema = await tq.buildSchema({
    resolvers,
    scalarsMap: [{ type: GraphQLScalarType, scalar: DateTimeResolver }],
    validate: { forbidUnknownValues: false },
    emitSchemaFile: path.resolve(__dirname, "schema.graphql"),
  })

  const server = new ApolloServer<Context>({ schema })

  const { url } = await startStandaloneServer(server, { context: async () => context })

  console.log(`
🚀 Server ready at: ${url}
⭐️  See sample queries: http://pris.ly/e/ts/graphql-typegraphql#using-the-graphql-api`
  )
}

app()
