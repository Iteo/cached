import 'dart:convert';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage extends CachedStorage {
  SharedPreferencesStorage._(this.sharedPreferences);

  late final SharedPreferences sharedPreferences;

  static Future<SharedPreferencesStorage> instance() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return SharedPreferencesStorage._(sharedPreferences);
  }

  @override
  Future<Map<String, dynamic>> read(String key) async {
    final value = sharedPreferences.getString(key);
    final hasValue = value != null && value.isNotEmpty;
    return hasValue ? jsonDecode(value) : {};
  }

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    final value = jsonEncode(data);
    final setString = sharedPreferences.setString(key, value);
    unawaited(setString);
  }

  @override
  Future<void> delete(String key) async {
    final remove = sharedPreferences.remove(key);
    unawaited(remove);
  }

  @override
  Future<void> deleteAll() async {
    final clear = sharedPreferences.clear();
    unawaited(clear);
  }
}
