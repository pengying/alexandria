import 'package:flutter/material.dart';
import 'package:papillon/models/book_list_model.dart';

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;

  late Future<List<BookListModel>> allBooks;


  void setBooks(Future<List<BookListModel>> allBooks) {
    this.allBooks = allBooks;
  }

  void setIndex(int index){
    selectedIndex = index;
    notifyListeners();
  }

  void addBook(BookListModel book) async {
    allBooks.then((value) => value.add(book));
  }
}
