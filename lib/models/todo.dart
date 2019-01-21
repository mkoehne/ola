class Todo {
  String _id;
  String _subject;
  bool _completed;
  String _userId;

  Todo(this._id, this._subject, this._completed);

  Todo.map(dynamic obj) {
    this._id = obj['id'];
    this._subject = obj['subject'];
    this._completed = obj['completed'];
    this._userId = obj['userId'];
  }

  String get id => _id;
  String get subject => _subject;
  bool get completed => _completed;
  String get userId => _userId;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['subject'] = _subject;
    map['completed'] = _completed;
    map['userId'] = _userId;

    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._subject = map['subject'];
    this._completed = map['description'];
    this._userId = map['userId'];
  }
}
