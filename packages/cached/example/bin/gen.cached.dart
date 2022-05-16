// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen.dart';

// **************************************************************************
// CachedGenerator
// **************************************************************************

abstract class _$Gen {
  int get a;
  String get b;
  String? get c;
}

class _Gen with Gen implements _$Gen {
  const _Gen(this.a, {required this.b, this.c});

  @override
  final int a;
  @override
  final String b;
  @override
  final String? c;

  static final _callSync = <String, Future<int>>{};

  static final _callCached = <String, int>{};
  static final _somethingCached = <String, int>{};

  static final _callTtl = <String, DateTime>{};

  @override
  Future<int> call(String arg1, {bool ignoreCache = true}) async {
    final now = DateTime.now();
    final currentTtl = _callTtl["${arg1.hashCode}"];

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _callTtl.remove("${arg1.hashCode}");
      _callCached.remove("${arg1.hashCode}");
    }

    final cachedValue = _callCached["${arg1.hashCode}"];
    if (cachedValue == null || ignoreCache) {
      final cachedFuture = _callSync["${arg1.hashCode}"];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final int toReturn;
      try {
        final result = super.call(arg1, ignoreCache: ignoreCache);
        _callSync['${arg1.hashCode}'] = result;
        toReturn = await result;
      } catch (_) {
        _callSync.remove('${arg1.hashCode}');
        if (cachedValue != null) {
          return cachedValue;
        }
        rethrow;
      } finally {
        _callSync.remove('${arg1.hashCode}');
      }

      _callCached["${arg1.hashCode}"] = toReturn;

      if (_callCached.length >= 10) {
        _callCached.remove(_callCached.entries.last.key);
      }

      _callTtl["${arg1.hashCode}"] =
          DateTime.now().add(const Duration(seconds: 30));

      return toReturn;
    }

    return cachedValue;
  }

  @override
  int something(String a, [int? b]) {
    final cachedValue = _somethingCached["${a.hashCode}${b.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.something(a, b);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _somethingCached["${a.hashCode}${b.hashCode}"] = toReturn;

      return toReturn;
    }

    return cachedValue;
  }
}
