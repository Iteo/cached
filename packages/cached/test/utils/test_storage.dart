import 'package:cached_annotation/cached_annotation.dart';

class TestStorage extends CachedStorage {
  @override
  Future<Map<String, dynamic>> read(String key) async => {};

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> deleteAll() async {}
}
