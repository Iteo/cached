// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen.dart';

// **************************************************************************
// CachedGenerator
// **************************************************************************

abstract class _$Gen {
  int get a;
}

class _Gen with Gen implements _$Gen {
  const _Gen(
    this.a,
  );

  @override
  final int a;

  static final _callCached = <String, int>{};

  static final _callSync = <String, Future<int>>{};

  static final _ttlMap = <String, DateTime>{};

  @override
  Future<int> call(String arg1, {bool ignoreCache = true}) async {
    final ttlKey = "call${arg1.hashCode}${ignoreCache.hashCode}";
    final now = DateTime.now();
    final currentTtl = _ttlMap[ttlKey];

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _ttlMap.remove(ttlKey);
      _callCached.remove("${arg1.hashCode}${ignoreCache.hashCode}");
    }

    final cachedValue = _callCached["${arg1.hashCode}${ignoreCache.hashCode}"];
    if (cachedValue == null || ignoreCache) {
      final cachedFuture = _callSync["${arg1.hashCode}${ignoreCache.hashCode}"];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final int toReturn;
      try {
        final result = super.call(arg1, ignoreCache: ignoreCache);
        _callSync['${arg1.hashCode}${ignoreCache.hashCode}'];
        toReturn = await result;
      } catch (_) {
        if (cachedValue != null) {
          return cachedValue;
        }
        _callSync.remove('${arg1.hashCode}${ignoreCache.hashCode}');
        rethrow;
      } finally {
        _callSync.remove('${arg1.hashCode}${ignoreCache.hashCode}');
      }

      if (_callCached.length >= 10) {
        _callCached.remove(_callCached.entries.last.key);
      }

      _ttlMap[ttlKey] = DateTime.now().add(const Duration(seconds: 30));

      return toReturn;
    }

    return cachedValue;
  }
}
