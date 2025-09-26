import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow(
    '[ERROR] Parameter: candidate (of type String) should match type int.')
@withCache
abstract class ShouldCacheIncompatibleTypes {
  factory ShouldCacheIncompatibleTypes() = _ShouldCacheIncompatibleTypes;

  @Cached(where: _shouldCacheStringCandidate)
  int cachedMethod() {
    return 1;
  }
}

bool _shouldCacheStringCandidate(String candidate) {
  return true;
}

@ShouldThrow(
    '[ERROR] Asynchronous and synchronous mismatch. Check return types of: '
    'cachedMethod and _shouldCacheAsyncAnnotated.')
@withCache
abstract class ShouldCacheAsyncAnnotated {
  factory ShouldCacheAsyncAnnotated() = _ShouldCacheAsyncAnnotated;

  @Cached(where: _shouldCacheAsyncAnnotated)
  Future<int> cachedMethod() {
    return 1;
  }
}

bool _shouldCacheAsyncAnnotated(int candidate) {
  return true;
}

@ShouldThrow(
    '[ERROR] Asynchronous and synchronous mismatch. Check return types of: '
    'cachedMethod and _shouldCacheAsyncCondition.')
@withCache
abstract class ShouldCacheAsyncCondition {
  factory ShouldCacheAsyncCondition() = _ShouldCacheAsyncCondition;

  @Cached(where: _shouldCacheAsyncCondition)
  int cachedMethod() {
    return 1;
  }
}

Future<bool> _shouldCacheAsyncCondition(int candidate) {
  return true;
}

@ShouldThrow(
    '[ERROR] `_shouldCacheReturnsVoid` must be a bool or Future<bool> method')
@withCache
abstract class ShouldCacheReturnsVoid {
  factory ShouldCacheReturnsVoid() = _ShouldCacheReturnsVoid;

  @Cached(where: _shouldCacheReturnsVoid)
  Future<int> cachedMethod() {
    return 1;
  }
}

void _shouldCacheReturnsVoid(int candidate) {}

@ShouldGenerate(r'''
abstract class _$AlwaysCache {}

class _AlwaysCache with AlwaysCache implements _$AlwaysCache {
  _AlwaysCache();

  final _cachedMethodCached = <String, int>{};

  @override
  int cachedMethod() {
    final cachedValue = _cachedMethodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      final shouldCache = _alwaysCache(toReturn);
      if (!shouldCache) {
        return toReturn;
      }

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
abstract class AlwaysCache {
  factory AlwaysCache() = _AlwaysCache;

  @Cached(where: _alwaysCache)
  int cachedMethod() {
    return 1;
  }
}

bool _alwaysCache(int candidate) {
  return true;
}

@ShouldGenerate(r'''
abstract class _$NeverCache {}

class _NeverCache with NeverCache implements _$NeverCache {
  _NeverCache();

  final _cachedMethodCached = <String, int>{};

  @override
  int cachedMethod() {
    final cachedValue = _cachedMethodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      final shouldCache = _neverCache(toReturn);
      if (!shouldCache) {
        return toReturn;
      }

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
abstract class NeverCache {
  factory NeverCache() = _NeverCache;

  @Cached(where: _neverCache)
  int cachedMethod() {
    return 1;
  }
}

bool _neverCache(int candidate) {
  return false;
}

@ShouldGenerate(r'''
abstract class _$Parameters {}

class _Parameters with Parameters implements _$Parameters {
  _Parameters();

  final _cachedMethodCached = <String, int>{};

  @override
  int cachedMethod(int x, String y) {
    final cachedValue = _cachedMethodCached["${y.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod(x, y);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      final shouldCache = _annotatedMethodHasParameters(toReturn);
      if (!shouldCache) {
        return toReturn;
      }

      _cachedMethodCached["${y.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
abstract class Parameters {
  factory Parameters() = _Parameters;

  @Cached(where: _annotatedMethodHasParameters)
  int cachedMethod(@ignore int x, String y) {
    return 1;
  }
}

bool _annotatedMethodHasParameters(int candidate) {
  return true;
}

@ShouldGenerate(r'''
abstract class _$AnnotatedMethodHasKey {}

class _AnnotatedMethodHasKey
    with AnnotatedMethodHasKey
    implements _$AnnotatedMethodHasKey {
  _AnnotatedMethodHasKey();

  final _cachedMethodCached = <String, int>{};

  @override
  Future<int> cachedMethod(List<int> x) async {
    final cachedValue = _cachedMethodCached["${iterableCacheKeyGenerator(x)}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod(x);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      final shouldCache = await _annotatedMethodHasKey(toReturn);
      if (!shouldCache) {
        return toReturn;
      }

      _cachedMethodCached["${iterableCacheKeyGenerator(x)}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
abstract class AnnotatedMethodHasKey {
  factory AnnotatedMethodHasKey() = _AnnotatedMethodHasKey;

  @Cached(where: _annotatedMethodHasKey)
  Future<int> cachedMethod(@iterableCacheKey List<int> x) {
    return x[0];
  }
}

Future<bool> _annotatedMethodHasKey(int candidate) {
  return true;
}

@ShouldGenerate(r'''
abstract class _$StaticCache {}

class _StaticCache with StaticCache implements _$StaticCache {
  _StaticCache();

  static final _cachedMethodCached = <String, int?>{};

  @override
  Future<int?> cachedMethod(int x) async {
    final cachedValue = _cachedMethodCached["${x.hashCode}"];
    if (cachedValue == null) {
      final int? toReturn;
      try {
        final result = super.cachedMethod(x);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      final shouldCache = await _useStaticCache(toReturn);
      if (!shouldCache) {
        return toReturn;
      }

      _cachedMethodCached["${x.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@WithCache(useStaticCache: true)
abstract class StaticCache {
  factory StaticCache() = _StaticCache;

  @Cached(where: _useStaticCache)
  Future<int?> cachedMethod(int x) {
    return y;
  }
}

Future<bool> _useStaticCache(int? candidate) {
  return true;
}

@ShouldGenerate(r'''
abstract class _$GenericCache {}

class _GenericCache with GenericCache implements _$GenericCache {
  _GenericCache();

  final _getListCached = <String, List<int>>{};

  @override
  Future<List<int>> getList() async {
    final cachedValue = _getListCached[""];
    if (cachedValue == null) {
      final List<int> toReturn;
      try {
        final result = super.getList();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      final shouldCache = await _shouldCacheGeneric(toReturn);
      if (!shouldCache) {
        return toReturn;
      }

      _getListCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@WithCache()
abstract class GenericCache {
  factory GenericCache() = _GenericCache;

  @Cached(where: _shouldCacheGeneric)
  Future<List<int>> getList() async {
    return [1, 2, 3];
  }
}

Future<bool> _shouldCacheGeneric<T>(List<T> result) async {
  return result.isNotEmpty;
}
