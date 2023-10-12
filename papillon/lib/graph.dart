import 'package:graphql/client.dart';
import 'package:papillon/models/book_model.dart';
import 'dart:developer' as developer;

final Link _httpLink = HttpLink(
  // const String.fromEnvironment('GRAPH_HOST'),
  "http://localhost:4000/graphql",
);

final GraphQLClient client = GraphQLClient(
  /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
  cache: GraphQLCache(),
  link: _httpLink,
);

/// subscriptions must be split otherwise `HttpLink` will. swallow them
/// TODO(Peng): change this to a book model
Future<QueryResult> generateBookFromPrompt(
    {required String name, required int age, required String prompt}) async {
  const String promptInput = r'''
mutation Mutation($prompt: PromptInput!) {
  generateBookFromPrompt(prompt: $prompt){
    title
    bookRaw {
      content
    }
  }
}
  ''';

  final MutationOptions options =
      MutationOptions(document: gql(promptInput), variables: <String, dynamic>{
    'prompt': <String, dynamic>{
      'age': age,
      'name': name,
      'prompt': prompt,
    },
  });

  final QueryResult result = await client.mutate(options);

  return result;
}

Future<List<BookModel>> listAllBooks() async {
  const listAllBooksQuery = """
query Books {
  books {
    bookRaw {
      content
      systemPrompt
      userPrompt
      completionTokens
      raw
      totalTokens
      model
    }
    title
    updatedAt
    createdAt
    uuid
    bookEdited {
      content
    }
  }
}
""";
  final QueryOptions options = QueryOptions(document: gql(listAllBooksQuery));

  final QueryResult result = await client.query(options);
  // TODO(Peng): add error handling
  developer.log(result.data.toString(), name: 'graph.listAllBooks');

  if (!result.hasException) {
    List<dynamic> queryBooks = result.data?['books'];
    return queryBooks
        .map((bookResult) => BookModel.fromQueryResult(queryResult: bookResult))
        .toList();
  } else {
    throw Exception('Failed to load books');
  }
}
