import 'package:graphql/client.dart';

String query = r'''
query Books {
  books {
    title
    bookRaw {
      content
    }
  }
}
''';

final QueryOptions options = QueryOptions(document: gql(query));

final Link _httpLink = HttpLink(
  'http://localhost:4000/',
);

/// subscriptions must be split otherwise `HttpLink` will. swallow them
GraphQLClient getClient() {
  return GraphQLClient(
    /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(),
    link: _httpLink,
  );
}

