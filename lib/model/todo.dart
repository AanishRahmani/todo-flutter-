import 'dart:convert';

class Todo {
  String? id;
  String? todoText;
  bool isDone;

  // Constructor
  Todo({this.id, this.todoText, this.isDone = false});

  //  object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }

  // Create a Todo object from a Map
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'],
    );
  }

  //  Todo to JSON format
  String toJson() => json.encode(toMap());

  // Todo object from a JSON string
  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));
}
