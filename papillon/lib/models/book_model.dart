class BookModel {
  final String title;
  final DateTime createdAt;
  final List<dynamic> rawContent;
  // late final List<String> editedContent;
  final String systemPrompt;
  final String userPrompt;

  BookModel(
      {required this.title,
      required this.createdAt,
      required this.rawContent,
      required this.systemPrompt,
      required this.userPrompt});

  factory BookModel.fromQueryResult(
      {required Map<String, dynamic> queryResult}) {
    var title = queryResult['title'] ?? "default title";
    var createdAt =
        DateTime.parse(queryResult['createdAt'] ?? "2023-01-01T00:00:00Z");
    final Map<String, dynamic>? bookRaw = queryResult['bookRaw'];
    List<dynamic> rawContent = ["default raw content"];
    String systemPrompt = "default system prompt";
    String userPrompt = "default user prompt";
    if (bookRaw != null) {
      rawContent = bookRaw['content'] ?? ["default raw content"];
      systemPrompt = bookRaw['systemPrompt'] ?? "default system prompt";
      userPrompt = bookRaw['userPrompt'] ?? "default user prompt";
    }
    return BookModel(
        createdAt: createdAt,
        title: title,
        rawContent: rawContent,
        systemPrompt: systemPrompt,
        userPrompt: userPrompt);
  }
}
