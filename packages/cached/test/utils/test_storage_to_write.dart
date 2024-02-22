import 'package:cached_annotation/cached_annotation.dart';

class TestStorageWithWrite extends CachedStorage {
  TestStorageWithWrite(this.storedValue);

  final Map<String, Map<String, dynamic>> storedValue;

  @override
  Future<Map<String, dynamic>> read(String key) async => storedValue[key]!;

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    storedValue[key] = data;
  }

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> deleteAll() async {}
}
