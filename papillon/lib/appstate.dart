import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:papillon/models/book_model.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var selectedIndex = 0;

  late Future<List<BookModel>> allBooks;
  late BookModel currentBook;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void setBooks(Future<List<BookModel>> allBooks) {
    this.allBooks = allBooks;
  }

  void setIndex(int index){
    selectedIndex = index;
    notifyListeners();
  }

  void setBook(BookModel book) {
    currentBook = book;
    selectedIndex = 2;
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
