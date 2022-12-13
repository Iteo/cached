/// Simple model class with fromJson and toJson methods
class Todo {
  Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        userId = json['userId'] as int,
        title = json['title'] as String,
        completed = json['completed'] as bool;

  final int userId;
  final int id;
  final String title;
  final bool completed;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'completed': completed,
      };

  @override
  String toString() {
    return 'Todo(id: $id, userId: $userId, title: $title, completed: $completed)\n';
  }
}
