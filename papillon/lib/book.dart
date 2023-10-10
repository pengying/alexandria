import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

class Book extends StatelessWidget {

  final QueryResult queryResult;

  const Book({super.key, required this.queryResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(queryResult.data?['generateBookFromPrompt']?['title'])
      ],);
  }

}