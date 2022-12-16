abstract class CachedStorage {
  Future<Map<String, dynamic>> read(String key);

  Future<void> write(String key, Map<String, dynamic> data);

  Future<void> delete(String key);

  Future<void> deleteAll();
}
