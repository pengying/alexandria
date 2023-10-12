import 'package:flutter/material.dart';
import 'package:papillon/appstate.dart';
import 'package:papillon/models/book_model.dart';
import 'package:papillon/screens/book_reader.dart';
import 'package:provider/provider.dart';

class BookList extends StatelessWidget {
  const BookList({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return FutureBuilder<List<BookModel>>(
        future: appState.allBooks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No books yet.'),
              );
            } else {
              return ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('You have '
                      '${snapshot.data!.length} books:'),
                ),
                for (var book in snapshot.data!)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookReader(book: book)));
                    },
                    child: ListTile(
                    // leading: const Icon(Icons.favorite),
                    title: Text(book.title),
                  )
                  )
              ]);
            }
          } else if (snapshot.hasError) {
            // TODO(Peng): fix this error handling
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}
