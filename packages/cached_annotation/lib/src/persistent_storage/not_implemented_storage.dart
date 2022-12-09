import 'package:cached_annotation/src/persistent_storage/cached_storage.dart';

class NotImplementedStorage extends CachedStorage {
  @override
  Future<Map<String, dynamic>> read(String key) async {
    print('Not implemented CachedStorage.read method.');
    return <String, dynamic>{};
  }

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    print('Not implemented CachedStorage.write method.');
  }

  @override
  Future<void> delete(String key) async {
    print('Not implemented CachedStorage.delete method.');
  }

  @override
  Future<void> deleteAll() async {
    print('Not implemented CachedStorage.deleteAll method.');
  }
}
