import 'dart:convert';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:hive/hive.dart';

/// Example Hive database configuration
const _path = './database/';
const _storageKey = '_ExampleHiveStorage';

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
class HiveStorage extends CachedStorage {
  HiveStorage._();

  /// You can connect to your storage asynchronously, but it isn't mandatory
  static Future<HiveStorage> create() async {
    Hive.init(_path);
    await Hive.openBox(_storageKey);

    return HiveStorage._();
  }

  /// In [write] method, you only have to provide a way to serialize
  /// your fresh data. This example uses one of the simplest ways:
  /// the [jsonEncode] method.
  ///
  /// Use a given [key] parameter as your key to store results.
  ///
  /// DO NOT modify [key] parameter value!
  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    final box = Hive.box(_storageKey);
    final encodedData = jsonEncode(data);

    return box.put(key, encodedData);
  }

  /// In [read] method, have to provide a way to read your previously serialized
  /// data. To be compatible with our [write] method, we'll use [jsonDecode].
  ///
  /// Use a [key] parameter as your key to read/filter results.
  ///
  /// DO NOT modify [key] parameter value!
  @override
  Future<Map<String, dynamic>> read(String key) async {
    final box = Hive.box(_storageKey);
    final position = box.get(key);
    final value = jsonDecode(position);

    return value;
  }

  /// In [delete] method, you have to provide a deletion logic only
  /// for a given key.
  ///
  /// DO NOT modify [key] parameter value!
  @override
  Future<void> delete(String key) async {
    final box = Hive.box(_storageKey);
    return box.delete(key);
  }

  /// In [deleteAll] method, you have to provide a deletion logic for
  /// all persisted data.
  @override
  Future<void> deleteAll() async {
    final box = Hive.box(_storageKey);
    return box.deleteFromDisk();
  }
}
