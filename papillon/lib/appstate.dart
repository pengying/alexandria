import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:papillon/book_model.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  late Future<List<BookModel>> allBooks;
  
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void setBooks(Future<List<BookModel>> allBooks) {
    allBooks = allBooks;
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
