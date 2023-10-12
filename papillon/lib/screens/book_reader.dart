import 'package:flutter/material.dart';
import 'package:papillon/models/book_model.dart';

class BookReader extends StatelessWidget {
  final BookModel book;
  const BookReader({super.key, required this.book});

  Widget bookComparison(BookModel book) {
    return Row(
      children: [
        ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
            ),
            for (var page in book.rawContent) Text(page)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book.title),
        ),
        body: Container(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('System Prompt:'),
                        Text(book.systemPrompt),
                        const Text('User Prompt: '),
                        Text(book.userPrompt),
                      ],
                    ),
                    Column(children: [Text('Created At: $book.createdAt')])
                  ],
                ),
              ],
            )));
  }
}
