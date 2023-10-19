class BookListModel {
  final String title;
  final String uuid;

  BookListModel({required this.title, required this.uuid});

  factory BookListModel.fromQueryResult({required Map<String, dynamic> queryResult}) {
    // Parse Book content
    var title = queryResult['title'] ?? "default title";
    var uuid = queryResult['uuid'] ?? "default uuid";
    return BookListModel(title: title, uuid: uuid);
  }
}