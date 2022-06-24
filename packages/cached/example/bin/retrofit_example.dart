import 'dart:convert';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_example.cached.dart';
part 'retrofit_example.g.dart';

@withCache
@RestApi(baseUrl: "https://jsonplaceholder.typicode.com/")
abstract class TodoApi {
  factory TodoApi(Dio dio) = _CachedTodoApi;

  @cached
  @GET("/todos/{id}")
  Future<Todo> getTodo(@Path() int id, {@ignoreCache bool ignoreCache = false});
}

@JsonSerializable()
class Todo {
  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  final int userId;
  final int id;
  final String title;
  final bool completed;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

void main() async {
  const _todoId = 94;

  final sw = Stopwatch();
  final encoder = JsonEncoder.withIndent('  ');
  final todoApi = TodoApi(Dio());

  for (int i = 0; i < 5; i++) {
    final sw = Stopwatch();
    sw.reset();
    sw.start();
    final todo = await todoApi.getTodo(_todoId);
    sw.stop();

    print("Request $i took ${sw.elapsedMilliseconds} ms");
    print(encoder.convert(todo.toJson()) + "\n");
  }

  sw.reset();
  sw.start();
  final todo = await todoApi.getTodo(_todoId, ignoreCache: true);
  sw.stop();

  print("Request with ignored cache took ${sw.elapsedMilliseconds} ms");
  print(encoder.convert(todo.toJson()) + "\n");
}
