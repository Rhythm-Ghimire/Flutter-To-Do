class Todo {
  int? id;
  String title;
  bool isCompleted;

  Todo({this.id, required this.title, this.isCompleted = false});

  // Convert to map for database
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted ? 1 : 0,
  };

  // Create from database map
  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
    id: map['id'],
    title: map['title'],
    isCompleted: map['isCompleted'] == 1,
  );
}