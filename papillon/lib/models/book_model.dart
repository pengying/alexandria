class CharacterModel {
  final String name;
  final String description;

  CharacterModel({required this.name, required this.description});

  @override
  String toString() {
    return 'name: $name\n description: $description';
  }

  factory CharacterModel.fromMap({required Map<String, dynamic> characterMap}) {
    return (CharacterModel(
        name: characterMap['name'], description: characterMap['description']));
  }
}

class BookModel {
  final String title;
  final DateTime createdAt;
  final String uuid;
  final String model;

  final List<dynamic> rawContent;
  final List<dynamic> rawScenes;
  final List<dynamic> editedContent;
  final List<dynamic> editedScenes;
  final List<CharacterModel> rawCharacters;
  final List<CharacterModel> editedCharacters;

  final String rawSystemPrompt;
  final String rawUserPrompt;
  final int rawPromptTokens;
  final int rawCompletionTokens;
  final int rawTotalTokens;

  final String editedSystemPrompt;
  final String editedUserPrompt;
  final int editedPromptTokens;
  final int editedCompletionTokens;
  final int editedTotalTokens;

  BookModel(
      {required this.title,
      required this.createdAt,
      required this.uuid,
      required this.model,
      required this.rawContent,
      required this.rawScenes,
      required this.editedContent,
      required this.editedScenes,
      required this.rawCharacters,
      required this.editedCharacters,
      required this.rawSystemPrompt,
      required this.rawUserPrompt,
      required this.rawPromptTokens,
      required this.rawCompletionTokens,
      required this.rawTotalTokens,
      required this.editedSystemPrompt,
      required this.editedUserPrompt,
      required this.editedPromptTokens,
      required this.editedCompletionTokens,
      required this.editedTotalTokens});

  factory BookModel.fromQueryResult(
      {required Map<String, dynamic> queryResult}) {
    // Parse Book content
    var title = queryResult['title'] ?? "default title";
    var uuid = queryResult['uuid'] ?? "default uuid";

    var createdAt =
        DateTime.parse(queryResult['createdAt'] ?? "2023-01-01T00:00:00Z");
    final Map<String, dynamic>? bookRaw = queryResult['bookRaw'];
    final Map<String, dynamic>? bookEdited = queryResult['bookEdited'];

    // Parse the raw book revision
    List<dynamic> rawContent = ["default content"];
    List<dynamic> rawScenes = ["default scenes"];
    List<CharacterModel> rawCharacters = [
      CharacterModel.fromMap(characterMap: {
        "name": "default name",
        "description": "default description"
      })
    ];
    String rawSystemPrompt = "default system prompt";
    String rawUserPrompt = "default user prompt";
    int rawPromptTokens = 0;
    int rawCompletionTokens = 0;
    int rawTotalTokens = 0;

    if (bookRaw != null) {
      rawContent = bookRaw['content'] ?? ["default raw content"];
      rawScenes = bookRaw['sceneDescription'] ?? ["default scenes"];
      rawSystemPrompt = bookRaw['systemPrompt'] ?? "default system prompt";
      rawUserPrompt = bookRaw['userPrompt'] ?? "default user prompt";
      if (bookRaw['characters'] != null) {
        rawCharacters = bookRaw['characters'].map<CharacterModel>((characterMap) =>
            CharacterModel.fromMap(characterMap: characterMap)).toList();
      }
      rawPromptTokens = bookRaw['promptTokens']?? 0;
      rawCompletionTokens = bookRaw['completionTokens']?? 0;
      rawTotalTokens = bookRaw['totalTokens']?? 0;
    }

    // Parse the edited book revision
    List<dynamic> editedContent = ["default content"];
    List<dynamic> editedScenes = ["default scenes"];
    List<CharacterModel> editedCharacters = [
      CharacterModel.fromMap(characterMap: {
        "name": "default name",
        "description": "default description"
      })
    ];
    String editedSystemPrompt = "default system prompt";
    String editedUserPrompt = "default user prompt";
    int editedPromptTokens = 0;
    int editedCompletionTokens = 0;
    int editedTotalTokens = 0;
    String model = "default model";
    if (bookEdited != null) {
      editedContent = bookEdited['content'] ?? ["default edited content"];
      editedScenes = bookEdited['sceneDescription'] ?? ["default scenes"];
      editedSystemPrompt =
          bookEdited['systemPrompt'] ?? "default system prompt";
      editedUserPrompt = bookEdited['userPrompt'] ?? "default user prompt";
      if (bookEdited['characters'] != null) {
        editedCharacters = bookEdited['characters'].map<CharacterModel>((characterMap) =>
            CharacterModel.fromMap(characterMap: characterMap)).toList();
      }
      editedPromptTokens = bookEdited['promptTokens'] ?? 0;
      editedCompletionTokens = bookEdited['completionTokens'] ?? 0;
      editedTotalTokens = bookEdited['totalTokens'] ?? 0;
      model = bookEdited['model']?? "default model";
    }

    return BookModel(
      createdAt: createdAt,
      uuid: uuid,
      title: title,
      model: model,
      rawContent: rawContent,
      rawSystemPrompt: rawSystemPrompt,
      rawUserPrompt: rawUserPrompt,
      rawScenes: rawScenes,
      rawCharacters: rawCharacters,
      rawCompletionTokens: rawCompletionTokens,
      rawPromptTokens: rawPromptTokens,
      rawTotalTokens: rawTotalTokens,
      editedCharacters: editedCharacters,
      editedContent: editedContent,
      editedScenes: editedScenes,
      editedCompletionTokens: editedCompletionTokens,
      editedPromptTokens: editedPromptTokens,
      editedSystemPrompt: editedSystemPrompt,
      editedTotalTokens: editedTotalTokens,
      editedUserPrompt: editedUserPrompt,
    );
  }
}
