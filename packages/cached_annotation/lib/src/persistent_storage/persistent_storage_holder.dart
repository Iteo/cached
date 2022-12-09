import 'package:cached_annotation/src/persistent_storage/cached_storage.dart';
import 'package:cached_annotation/src/persistent_storage/not_implemented_storage.dart';

class PersistentStorageHolder {
  static CachedStorage _storage = NotImplementedStorage();

  static bool get isStorageSet => _storage is! NotImplementedStorage;

  static set storage(CachedStorage value) {
    _storage = value;
  }

  static Future<void> write(String key, Map<String, dynamic> data) {
    return _storage.write(key, data);
  }

  static Future<Map<String, dynamic>> read(String key) {
    return _storage.read(key);
  }

  static Future<void> delete(String key) {
    return _storage.delete(key);
  }

  static Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
