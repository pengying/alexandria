import 'package:flutter/material.dart';
import 'package:papillon/models/book_model.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';

class BookReader extends StatelessWidget {
  final BookModel book;
  const BookReader({super.key, required this.book});

  /// Helper to render different comparisons
  Widget _comparisonHelper({
    required List<dynamic> rawContent,
    required List<dynamic> editedContent,
    required String comparisonType,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text('$comparisonType Raw Response'),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: rawContent.length,
                prototypeItem: ListTile(
                  title: Text(rawContent[0]),
                ),
                itemBuilder: (context, index) {
                  return ListTile(title: Text(rawContent[index]));
                },
              )
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Column(children: [
              Text('$comparisonType Edited Response'),
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: editedContent.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: PrettyDiffText(
                            defaultTextStyle:
                                DefaultTextStyle.of(context).style,
                            oldText: rawContent[index],
                            newText: editedContent[index]));
                  }),
            ]))
      ],
    );
  }

  /// Renders the comparison between the original book and the edited book
  Widget bookComparison(BookModel book) {
    return _comparisonHelper(
        rawContent: book.rawContent,
        editedContent: book.editedContent,
        comparisonType: 'Book');
  }

  /// Renders comparison between characters
  Widget characterComparison(BookModel book) {
    return _comparisonHelper(
        rawContent: book.rawCharacters.map((e) => e.toString()).toList(),
        editedContent: book.editedCharacters.map((e) => e.toString()).toList(),
        comparisonType: 'Character');
  }

  Widget sceneComparison(BookModel book) {
    return _comparisonHelper(
        rawContent: book.rawScenes,
        editedContent: book.editedScenes,
        comparisonType: 'Scenes');
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
              Text('Created At: ${book.createdAt.toLocal()}'),
              Text('Model: ${book.model}'),
              const Text('System Prompt:'),
              Text(book.rawSystemPrompt),
              const Text('User Prompt: '),
              Text(book.rawUserPrompt),
              Text('Raw Prompt Tokens: ${book.rawPromptTokens}'),
              Text('Raw Completion Tokens: ${book.rawCompletionTokens}'),
              Text('Raw Total Tokens: ${book.rawTotalTokens}'),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text('System Prompt:'),
                Text(book.editedSystemPrompt),
                const Text('User Prompt: '),
                Text(book.editedUserPrompt),
                Text('Edited Prompt Tokens: ${book.editedPromptTokens}'),
                Text(
                    'Edited Completion Tokens: ${book.editedCompletionTokens}'),
                Text('Edited Total Tokens: ${book.editedTotalTokens}'),
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
                    characterComparison(book),
                    sceneComparison(book),
                  ],
                ))));
  }
}
