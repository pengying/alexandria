import 'package:graphql/client.dart';

final Link _httpLink = HttpLink(
  'http://localhost:4000/',
);

final GraphQLClient client = GraphQLClient(
  /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
  cache: GraphQLCache(),
  link: _httpLink,
);

/// subscriptions must be split otherwise `HttpLink` will. swallow them
Future<QueryResult> generateBookFromPrompt(
    {required String name, required int age, required String prompt}) async {
  const String promptInput = r'''
  mutation Mutation($prompt: PromptInput!) {
    generateBookFromPrompt(prompt: $prompt)
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
