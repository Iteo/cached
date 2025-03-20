import 'package:hive_ce/hive.dart';

/// Required for code generation
part 'todo.g.dart';

/// Simple model class with [fromJson] and [toJson] methods, prepared for
/// Hive [TypeAdapter] code generation
@HiveType(typeId: 0)
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

  @HiveField(0)
  final int userId;
  @HiveField(1)
  final int id;
  @HiveField(2)
  final String title;
  @HiveField(3)
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
