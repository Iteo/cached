import 'package:cached_annotation/cached_annotation.dart';
import 'package:hive_ce/hive.dart';

import 'todo.dart';

/// Example Hive database configuration
const _path = './database/';
const _storageKey = '_todos';

/// You have to extend [CachedStorage] to use Cached library's persistent
/// storage functionality. You have to provide your own CRUD logic by
/// overriding all base methods.
///
/// Cached library is persisting data in a {key: value} manner. It'll give you
/// a key and it is your responsibility to serialize it so that you can
/// deserialize it later with the same key.
///
/// Important:
/// Please be aware of typing and error handling. This has to be done on your
/// side.
class TodoStorage extends CachedStorage {
  TodoStorage._();

  /// You can connect to your storage asynchronously, but it isn't mandatory
  static Future<TodoStorage> create() async {
    Hive.init(_path);
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Map>(_storageKey);

    return TodoStorage._();
  }

  /// In [write] method, you only have to provide a way to serialize
  /// your fresh data. In our case, Hive is doing the job for us with
  /// its adapter.
  ///
  /// Use a given [key] parameter as your key to store results.
  ///
  /// DO NOT modify [key] parameter value!
  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    final box = Hive.box<Map>(_storageKey);
    return box.put(key, data);
  }

  /// In [read] method, have to provide a way to read your previously serialized
  /// data. Again, in this example, Hive is doing the job for us.
  ///
  /// Use a [key] parameter as your key to read/filter results.
  ///
  /// DO NOT modify [key] parameter value!
  @override
  Future<Map<String, dynamic>> read(String key) async {
    final box = Hive.box<Map>(_storageKey);
    final result = box.get(key) ?? {};

    /// This is necessary for generic classes to provide compatibility
    /// with Hive, because it can only return
    /// `Map<dynamic, dynamic>`, not `Map<String, dynamic>`
    return result.cast<String, dynamic>();
  }

  /// In [delete] method, you have to provide a deletion logic only
  /// for a given key.
  ///
  /// DO NOT modify [key] parameter value!
  @override
  Future<void> delete(String key) async {
    final box = Hive.box<Map>(_storageKey);
    return box.delete(key);
  }

  /// In [deleteAll] method, you have to provide a deletion logic for
  /// all persisted data.
  @override
  Future<void> deleteAll() async {
    final box = Hive.box<Map>(_storageKey);
    return box.deleteFromDisk();
  }
}
