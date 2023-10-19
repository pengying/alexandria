import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:papillon/graph.dart';
import 'package:papillon/screens/prompt.dart';
import 'package:papillon/screens/book_list.dart';
import 'package:papillon/screens/book_reader.dart';
import 'package:provider/provider.dart';

import 'themes.dart';
import 'appstate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Alexandria App',
        theme: theme,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MyAppState>(context, listen: false).setBooks(listAllBooksMin());
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;
    switch (appState.selectedIndex) {
      case 0:
        page = Prompt();
        break;
      case 1:
        page = BookList();
        break;
      // case 2:
      //   page = BookReader(book: appState.currentBook);
      //   break;
      default:
        throw UnimplementedError('no widget for $appState.selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  const NavigationRailDestination(
                    icon: Icon(Icons.edit),
                    label: Text('Prompt'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.auto_stories),
                    label: Text('Books'),
                  ),
                ],
                selectedIndex: appState.selectedIndex,
                onDestinationSelected: (value) {
                  appState.setIndex(value);
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
