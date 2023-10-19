import 'package:graphql/client.dart';
import 'package:papillon/models/book_list_model.dart';
import 'package:papillon/models/book_model.dart';
import 'dart:developer' as developer;

const String _apiUrl = String.fromEnvironment('API_URL',
    defaultValue: 'https://shujia-api.appliedml.dev/');
final Link _httpLink = HttpLink(
  _apiUrl,
);

const String allFields = '''
title
updatedAt
createdAt
uuid
bookRaw {
  content
  systemPrompt
  userPrompt
  completionTokens
  raw
  totalTokens
  model
  sceneDescription
  characters {
    name
    description
  }
}
bookEdited {
  content
  systemPrompt
  userPrompt
  completionTokens
  raw
  totalTokens
  sceneDescription
  characters {
    name
    description
  }
}
''';

final GraphQLClient client = GraphQLClient(
  /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
  cache: GraphQLCache(),
  link: _httpLink,
);

Future<List<BookListModel>> listAllBooksMin() async {
  const listAllBooksMinQuery = """
query Books {
  books {
    $allFields
  }
}
""";

  final QueryOptions options =
      QueryOptions(document: gql(listAllBooksMinQuery));

  final QueryResult result = await client.query(options);
  developer.log(result.data.toString(), name: 'graph.listAllBooks');
  developer.log(_apiUrl, name: 'API server');

  if (!result.hasException) {
    List<dynamic> queryBooks = result.data?['books'];
    return queryBooks
        .map((bookResult) =>
            BookListModel.fromQueryResult(queryResult: bookResult))
        .toList();
  } else {
    throw Exception('Failed to load books');
  }
}

Future<BookModel> getBook({required String uuid}) async {
  const getBookQuery = """
query Query(\$where: BookWhereUniqueInput!) {
  book(where: \$where) {
    $allFields
  }
}
""";
  final QueryOptions options = QueryOptions(
    document: gql(getBookQuery),
    variables: <String, dynamic>{
      'where': {'uuid': uuid},
    },
  );
  final QueryResult result = await client.query(options);
  if (!result.hasException) {
    var queryBook = result.data?['book'];
    return BookModel.fromQueryResult(queryResult: queryBook);
  } else {
    throw Exception('Failed to load books');
  }
}

/// subscriptions must be split otherwise `HttpLink` will. swallow them
/// TODO(Peng): change this to a book model
Future<QueryResult> generateBookFromPrompt(
    {required String name,
    required int age,
    required String userPrompt,
    String? systemPrompt,
    String? editPrompt}) async {
  const String promptInput = r'''
mutation Mutation($prompt: PromptInput!) {
  generateBookFromPrompt(prompt: $prompt){
    title
    updatedAt
    createdAt
    uuid
    bookRaw {
      content
      systemPrompt
      userPrompt
      completionTokens
      raw
      totalTokens
      model
      sceneDescription
      characters {
        name
        description
      }
    }
    bookEdited {
      content
      systemPrompt
      userPrompt
      completionTokens
      raw
      totalTokens
      sceneDescription
      characters {
        name
        description
      }
    }
  }
}
  ''';

  final MutationOptions options =
      MutationOptions(document: gql(promptInput), variables: <String, dynamic>{
    'prompt': <String, dynamic>{
      'age': age,
      'name': name,
      'userPrompt': userPrompt,
      'systemPrompt': systemPrompt,
      'editPrompt': editPrompt,
    },
  });

  final QueryResult result = await client.mutate(options);

  return result;
}

Future<List<BookModel>> listAllBooks() async {
  const listAllBooksQuery = """
query Books {
  books {
    title
    updatedAt
    createdAt
    uuid
    bookRaw {
      content
      systemPrompt
      userPrompt
      completionTokens
      raw
      totalTokens
      model
      sceneDescription
      characters {
        name
        description
      }
    }
    bookEdited {
      content
      systemPrompt
      userPrompt
      completionTokens
      raw
      totalTokens
      sceneDescription
      characters {
        name
        description
      }
    }
  }
}
""";
  final QueryOptions options = QueryOptions(document: gql(listAllBooksQuery));

  final QueryResult result = await client.query(options);
  // TODO(Peng): add error handling
  developer.log(result.data.toString(), name: 'graph.listAllBooks');
  developer.log(_apiUrl, name: 'API server');

  if (!result.hasException) {
    List<dynamic> queryBooks = result.data?['books'];
    return queryBooks
        .map((bookResult) => BookModel.fromQueryResult(queryResult: bookResult))
        .toList();
  } else {
    throw Exception('Failed to load books');
  }
}
