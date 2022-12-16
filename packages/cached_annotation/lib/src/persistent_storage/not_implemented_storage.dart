import 'package:cached_annotation/src/persistent_storage/cached_storage.dart';

const _message = 'CachedStorage is not set. In main.dart add: '
    'PersistentStorageHolder.storage = YourStorage(); '
    'See the documentation and project examples for more code snippets.';

class NotImplementedStorage extends CachedStorage {
  @override
  Future<void> delete(String key) async {
    throw UnimplementedError(_message);
  }

  @override
  Future<void> deleteAll() async {
    throw UnimplementedError(_message);
  }

  @override
  Future<Map<String, dynamic>> read(String key) async {
    throw UnimplementedError(_message);
  }

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    throw UnimplementedError(_message);
  }
}
