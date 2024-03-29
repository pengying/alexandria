import 'package:flutter/material.dart';
import 'package:papillon/graph.dart';
import 'package:papillon/models/book_model.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';

class BookReader extends StatefulWidget {
  final String bookUuid;

  const BookReader({super.key, required this.bookUuid});

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> with TickerProviderStateMixin {
  late final Future<BookModel> book;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    book = getBook(uuid: widget.bookUuid);
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
              for (var page in rawContent)
                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(page))
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Column(children: [
              Text('$comparisonType Edited Response'),
              for (var index = 0; index < editedContent.length; index++)
                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: PrettyDiffText(
                        oldText: rawContent[index],
                        newText: editedContent[index]))
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
    return FutureBuilder<BookModel>(
        future: book,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(snapshot.data!.title),
                ),
                body: SingleChildScrollView(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        bookHeader(snapshot.data!),
                        bookComparison(snapshot.data!),
                        characterComparison(snapshot.data!),
                        sceneComparison(snapshot.data!),
                      ],
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Circular progress indicator',
              ),
            );
          }
        });
  }
}
