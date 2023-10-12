import 'package:flutter/material.dart';
import 'package:papillon/models/book_model.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';

class BookReader extends StatelessWidget {
  final BookModel book;
  const BookReader({super.key, required this.book});

  Widget bookComparison(BookModel book) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Text('Raw Response'),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: book.rawContent.length,
                prototypeItem: ListTile(
                  title: Text(book.rawContent[0]),
                ),
                itemBuilder: (context, index) {
                  return ListTile(title: Text(book.rawContent[index]));
                },
              )
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Column(children: [
              const Text('Edited Response'),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: book.rawContent.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: PrettyDiffText(
                            oldText: book.rawContent[index],
                            newText: book.rawContent[index] + "test"));
                  }),
            ]))
      ],
    );
  }

  /// Displays meta information about the book
  /// - Prompts
  /// - Tokens used
  Widget bookHeader(BookModel book) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('System Prompt:'),
              Text(book.systemPrompt),
              const Text('User Prompt: '),
              Text(book.userPrompt),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Column(
              children: [
                Text('Created At: ${book.createdAt.toLocal()}'),
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book.title),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    bookHeader(book),
                    bookComparison(book),
                  ],
                ))));
  }
}
