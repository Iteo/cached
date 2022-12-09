import 'dart:convert';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

const _storageKey = '_HiveStorage';

class HiveStorage extends CachedStorage {
  HiveStorage._();

  static Future<HiveStorage> create() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    Hive.init(path);
    await Hive.openBox(_storageKey);

    return HiveStorage._();
  }

  @override
  Future<Map<String, dynamic>> read(String key) async {
    final box = Hive.box(_storageKey);
    final position = box.get(key);
    final value = jsonDecode(position);

    return value;
  }

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    final box = Hive.box(_storageKey);
    final encodedData = jsonEncode(data);

    return box.put(key, encodedData);
  }

  @override
  Future<void> delete(String key) async {
    final box = Hive.box(_storageKey);
    return box.delete(key);
  }

  @override
  Future<void> deleteAll() async {
    final box = Hive.box(_storageKey);
    return box.deleteFromDisk();
  }
}
