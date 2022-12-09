import 'package:cached_annotation/cached_annotation.dart';

class MockStorageImpl extends CachedStorage {
  final _storage = _MockStorage();

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key);
  }

  @override
  Future<Map<String, dynamic>> read(String key) async {
    return await _storage.read(key) ?? {};
  }

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    await _storage.write(key, data);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

class _MockStorage {
  final Map<String, Map<String, dynamic>> _storage = {};

  static const _delay = Duration(milliseconds: 200);

  Future<void> write(String key, Map<String, dynamic> data) async {
    await Future<void>.delayed(_delay);
    _storage[key] = data;
  }

  Future<Map<String, dynamic>?> read(String key) async {
    await Future<void>.delayed(_delay);
    return _storage[key];
  }

  Future<void> delete(String key) async {
    await Future<void>.delayed(_delay);
    _storage.remove(key);
  }

  Future<void> deleteAll() async {
    await Future<void>.delayed(_delay);
    _storage.clear();
  }
}
