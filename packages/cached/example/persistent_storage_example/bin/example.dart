import 'package:cached_annotation/cached_annotation.dart';

import 'gen.dart';
import 'hive_storage.dart';
import 'todo.dart';

/// Open [cached_example] project in ../example directory to check
/// how use [Cached] package.
final _gen = Gen();

/// Run this method. It'll create a database folder with two files:
/// - _examplehivestorage.hive
/// - _examplehivestorage.lock
///
/// From now on, every program run will use data stored in these files.
///
/// Examples of fetching times:
/// - 1st run: 306 ms
/// - 2nd run: 8 ms
/// - Delete ./database directory  manually or with [_gen.clearTodos] method
/// - 3rd run: 298 ms
Future<void> main(List<String> arguments) async {
  /// The assignment of this variable is mandatory for [Cached] to store
  /// data in permanent memory.
  PersistentStorageHolder.storage = await HiveStorage.create();

  /// Uncomment to deleteTodos
  // await _gen.clearTodos();

  await _fetchTodos();
}

Future<void> _fetchTodos() async {
  final stopwatch = Stopwatch();

  stopwatch.start();
  final rawTodos = await _gen.getTodos();
  final todos = rawTodos.map((e) => Todo.fromJson(e)).toList();
  stopwatch.stop();

  final count = todos.length;
  print('Todos count: $count items');

  final fetchTime = stopwatch.elapsedMilliseconds;
  print('Fetch time: $fetchTime ms \n');

  print('First 5 todos:');
  print(todos.sublist(0, 5));
}
