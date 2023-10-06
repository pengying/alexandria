import 'package:gql/ast.dart';

class Query$Books {
  Query$Books({
    required this.books,
    this.$__typename = 'Query',
  });

  factory Query$Books.fromJson(Map<String, dynamic> json) {
    final l$books = json['books'];
    final l$$__typename = json['__typename'];
    return Query$Books(
      books: (l$books as List<dynamic>)
          .map((e) => Query$Books$books.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$Books$books> books;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$books = books;
    _resultData['books'] = l$books.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$books = books;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$books.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Books) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$books = books;
    final lOther$books = other.books;
    if (l$books.length != lOther$books.length) {
      return false;
    }
    for (int i = 0; i < l$books.length; i++) {
      final l$books$entry = l$books[i];
      final lOther$books$entry = lOther$books[i];
      if (l$books$entry != lOther$books$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Books on Query$Books {
  CopyWith$Query$Books<Query$Books> get copyWith => CopyWith$Query$Books(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Books<TRes> {
  factory CopyWith$Query$Books(
    Query$Books instance,
    TRes Function(Query$Books) then,
  ) = _CopyWithImpl$Query$Books;

  factory CopyWith$Query$Books.stub(TRes res) = _CopyWithStubImpl$Query$Books;

  TRes call({
    List<Query$Books$books>? books,
    String? $__typename,
  });
  TRes books(
      Iterable<Query$Books$books> Function(
              Iterable<CopyWith$Query$Books$books<Query$Books$books>>)
          _fn);
}

class _CopyWithImpl$Query$Books<TRes> implements CopyWith$Query$Books<TRes> {
  _CopyWithImpl$Query$Books(
    this._instance,
    this._then,
  );

  final Query$Books _instance;

  final TRes Function(Query$Books) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? books = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Books(
        books: books == _undefined || books == null
            ? _instance.books
            : (books as List<Query$Books$books>),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes books(
          Iterable<Query$Books$books> Function(
                  Iterable<CopyWith$Query$Books$books<Query$Books$books>>)
              _fn) =>
      call(
          books: _fn(_instance.books.map((e) => CopyWith$Query$Books$books(
                e,
                (i) => i,
              ))).toList());
}

class _CopyWithStubImpl$Query$Books<TRes>
    implements CopyWith$Query$Books<TRes> {
  _CopyWithStubImpl$Query$Books(this._res);

  TRes _res;

  call({
    List<Query$Books$books>? books,
    String? $__typename,
  }) =>
      _res;

  books(_fn) => _res;
}

const documentNodeQueryBooks = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'Books'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'books'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'title'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'bookRaw'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'content'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'userPrompt'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);

class Query$Books$books {
  Query$Books$books({
    required this.title,
    this.bookRaw,
    this.$__typename = 'Book',
  });

  factory Query$Books$books.fromJson(Map<String, dynamic> json) {
    final l$title = json['title'];
    final l$bookRaw = json['bookRaw'];
    final l$$__typename = json['__typename'];
    return Query$Books$books(
      title: (l$title as String),
      bookRaw: l$bookRaw == null
          ? null
          : Query$Books$books$bookRaw.fromJson(
              (l$bookRaw as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String title;

  final Query$Books$books$bookRaw? bookRaw;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$title = title;
    _resultData['title'] = l$title;
    final l$bookRaw = bookRaw;
    _resultData['bookRaw'] = l$bookRaw?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$title = title;
    final l$bookRaw = bookRaw;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$title,
      l$bookRaw,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Books$books) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$bookRaw = bookRaw;
    final lOther$bookRaw = other.bookRaw;
    if (l$bookRaw != lOther$bookRaw) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Books$books on Query$Books$books {
  CopyWith$Query$Books$books<Query$Books$books> get copyWith =>
      CopyWith$Query$Books$books(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Books$books<TRes> {
  factory CopyWith$Query$Books$books(
    Query$Books$books instance,
    TRes Function(Query$Books$books) then,
  ) = _CopyWithImpl$Query$Books$books;

  factory CopyWith$Query$Books$books.stub(TRes res) =
      _CopyWithStubImpl$Query$Books$books;

  TRes call({
    String? title,
    Query$Books$books$bookRaw? bookRaw,
    String? $__typename,
  });
  CopyWith$Query$Books$books$bookRaw<TRes> get bookRaw;
}

class _CopyWithImpl$Query$Books$books<TRes>
    implements CopyWith$Query$Books$books<TRes> {
  _CopyWithImpl$Query$Books$books(
    this._instance,
    this._then,
  );

  final Query$Books$books _instance;

  final TRes Function(Query$Books$books) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? title = _undefined,
    Object? bookRaw = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Books$books(
        title: title == _undefined || title == null
            ? _instance.title
            : (title as String),
        bookRaw: bookRaw == _undefined
            ? _instance.bookRaw
            : (bookRaw as Query$Books$books$bookRaw?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Books$books$bookRaw<TRes> get bookRaw {
    final local$bookRaw = _instance.bookRaw;
    return local$bookRaw == null
        ? CopyWith$Query$Books$books$bookRaw.stub(_then(_instance))
        : CopyWith$Query$Books$books$bookRaw(
            local$bookRaw, (e) => call(bookRaw: e));
  }
}

class _CopyWithStubImpl$Query$Books$books<TRes>
    implements CopyWith$Query$Books$books<TRes> {
  _CopyWithStubImpl$Query$Books$books(this._res);

  TRes _res;

  call({
    String? title,
    Query$Books$books$bookRaw? bookRaw,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Books$books$bookRaw<TRes> get bookRaw =>
      CopyWith$Query$Books$books$bookRaw.stub(_res);
}

class Query$Books$books$bookRaw {
  Query$Books$books$bookRaw({
    required this.content,
    this.userPrompt,
    this.$__typename = 'BookRevision',
  });

  factory Query$Books$books$bookRaw.fromJson(Map<String, dynamic> json) {
    final l$content = json['content'];
    final l$userPrompt = json['userPrompt'];
    final l$$__typename = json['__typename'];
    return Query$Books$books$bookRaw(
      content: (l$content as List<dynamic>).map((e) => (e as String)).toList(),
      userPrompt: (l$userPrompt as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final List<String> content;

  final String? userPrompt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$content = content;
    _resultData['content'] = l$content.map((e) => e).toList();
    final l$userPrompt = userPrompt;
    _resultData['userPrompt'] = l$userPrompt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$content = content;
    final l$userPrompt = userPrompt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$content.map((v) => v)),
      l$userPrompt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Books$books$bookRaw) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$content = content;
    final lOther$content = other.content;
    if (l$content.length != lOther$content.length) {
      return false;
    }
    for (int i = 0; i < l$content.length; i++) {
      final l$content$entry = l$content[i];
      final lOther$content$entry = lOther$content[i];
      if (l$content$entry != lOther$content$entry) {
        return false;
      }
    }
    final l$userPrompt = userPrompt;
    final lOther$userPrompt = other.userPrompt;
    if (l$userPrompt != lOther$userPrompt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Books$books$bookRaw
    on Query$Books$books$bookRaw {
  CopyWith$Query$Books$books$bookRaw<Query$Books$books$bookRaw> get copyWith =>
      CopyWith$Query$Books$books$bookRaw(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Books$books$bookRaw<TRes> {
  factory CopyWith$Query$Books$books$bookRaw(
    Query$Books$books$bookRaw instance,
    TRes Function(Query$Books$books$bookRaw) then,
  ) = _CopyWithImpl$Query$Books$books$bookRaw;

  factory CopyWith$Query$Books$books$bookRaw.stub(TRes res) =
      _CopyWithStubImpl$Query$Books$books$bookRaw;

  TRes call({
    List<String>? content,
    String? userPrompt,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Books$books$bookRaw<TRes>
    implements CopyWith$Query$Books$books$bookRaw<TRes> {
  _CopyWithImpl$Query$Books$books$bookRaw(
    this._instance,
    this._then,
  );

  final Query$Books$books$bookRaw _instance;

  final TRes Function(Query$Books$books$bookRaw) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? userPrompt = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Books$books$bookRaw(
        content: content == _undefined || content == null
            ? _instance.content
            : (content as List<String>),
        userPrompt: userPrompt == _undefined
            ? _instance.userPrompt
            : (userPrompt as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Books$books$bookRaw<TRes>
    implements CopyWith$Query$Books$books$bookRaw<TRes> {
  _CopyWithStubImpl$Query$Books$books$bookRaw(this._res);

  TRes _res;

  call({
    List<String>? content,
    String? userPrompt,
    String? $__typename,
  }) =>
      _res;
}
