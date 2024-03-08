import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

//MODIFIED CACHED METHOD GENERATION TEST INPUT

@ShouldThrow(
    '[ERROR] Method Getter returns void or Future<void> which is not allowed')
@withCache
abstract class VoidGetter {
  factory VoidGetter() = _VoidGetter;

  @cached
  void get Getter {}
}

@ShouldThrow(
    '[ERROR] Method Getter returns void or Future<void> which is not allowed')
@withCache
abstract class FutureVoidGetter {
  factory FutureVoidGetter() = _FutureVoidGetter;

  @cached
  Future<void> get Getter async {}
}

@ShouldThrow('[ERROR] Cached method Getter is abstract which is not allowed')
@withCache
abstract class AbstractGetter {
  factory AbstractGetter() = _AbstractGetter;

  @cached
  Future<int> get Getter;
}

@ShouldGenerate(
  r'''
abstract class _$Getter {}

class _Getter with Getter implements _$Getter {
  _Getter();

  final _getterCached = <String, int>{};

  @override
  int get getter {
    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.getter;

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _getterCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class Getter {
  factory Getter() = _Getter;

  @cached
  int get getter {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncGet {}

class _AsyncGet with AsyncGet implements _$AsyncGet {
  _AsyncGet();

  final _getterCached = <String, int>{};

  @override
  Future<int> get getter async {
    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.getter;

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getterCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class AsyncGet {
  factory AsyncGet() = _AsyncGet;

  @cached
  Future<int> get getter {
    return Future.value(1);
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncGeneratorGetter {}

class _AsyncGeneratorGetter
    with AsyncGeneratorGetter
    implements _$AsyncGeneratorGetter {
  _AsyncGeneratorGetter();

  final _getterCached = <String, Stream<int>>{};

  @override
  Stream<int> get getter async* {
    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final Stream<int> toReturn;
      try {
        final result = super.getter;

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _getterCached[""] = toReturn;

      yield* toReturn;
    } else {
      yield* cachedValue;
    }
  }
}
''',
)
@withCache
abstract class AsyncGeneratorGetter {
  factory AsyncGeneratorGetter() = _AsyncGeneratorGetter;

  @cached
  Stream<int> get getter async* {
    yield 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$SyncGeneratorGetter {}

class _SyncGeneratorGetter
    with SyncGeneratorGetter
    implements _$SyncGeneratorGetter {
  _SyncGeneratorGetter();

  final _getterCached = <String, Iterable<int>>{};

  @override
  Iterable<int> get getter sync* {
    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final Iterable<int> toReturn;
      try {
        final result = super.getter;

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _getterCached[""] = toReturn;

      yield* toReturn;
    } else {
      yield* cachedValue;
    }
  }
}
''',
)
@withCache
abstract class SyncGeneratorGetter {
  factory SyncGeneratorGetter() = _SyncGeneratorGetter;

  @cached
  Iterable<int> get getter sync* {
    yield 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$CachedWithLimit {}

class _CachedWithLimit with CachedWithLimit implements _$CachedWithLimit {
  _CachedWithLimit();

  final _getterCached = <String, int>{};

  @override
  int get getter {
    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.getter;

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _getterCached[""] = toReturn;

      if (_getterCached.length > 10) {
        _getterCached.remove(_getterCached.entries.first.key);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class CachedWithLimit {
  factory CachedWithLimit() = _CachedWithLimit;

  @Cached(limit: 10)
  int get getter {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$CachedWithTtl {}

class _CachedWithTtl with CachedWithTtl implements _$CachedWithTtl {
  _CachedWithTtl();

  final _getterCached = <String, int>{};

  final _getterTtl = <String, String>{};

  @override
  int get getter {
    final now = DateTime.now();
    final cachedTtl = _getterTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getterTtl.remove("");
      _getterCached.remove("");
    }

    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.getter;

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _getterCached[""] = toReturn;

      const duration = Duration(seconds: 30);
      _getterTtl[""] = DateTime.now().add(duration).toIso8601String();

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class CachedWithTtl {
  factory CachedWithTtl() = _CachedWithTtl;

  @Cached(ttl: 30)
  int get getter {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncSyncWrite {}

class _AsyncSyncWrite with AsyncSyncWrite implements _$AsyncSyncWrite {
  _AsyncSyncWrite();

  final _getterSync = <String, Future<int>>{};

  final _getterCached = <String, int>{};

  @override
  Future<int> get getter async {
    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getterSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final int toReturn;
      try {
        final result = super.getter;
        _getterSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getterSync.remove('');
      }

      _getterCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class AsyncSyncWrite {
  factory AsyncSyncWrite() = _AsyncSyncWrite;

  @Cached(syncWrite: true)
  Future<int> get getter async {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$SyncSyncWrite {}

class _SyncSyncWrite with SyncSyncWrite implements _$SyncSyncWrite {
  _SyncSyncWrite();

  final _getterSync = <String, Future<int>>{};

  final _getterCached = <String, int>{};

  @override
  int get getter {
    final cachedValue = _getterCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.getter;

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _getterCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class SyncSyncWrite {
  factory SyncSyncWrite() = _SyncSyncWrite;

  @Cached(syncWrite: true)
  int get getter {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$PersistentCachedGetter {}

class _PersistentCachedGetter
    with PersistentCachedGetter
    implements _$PersistentCachedGetter {
  _PersistentCachedGetter() {
    _init();
  }

  Future<void> _init() async {
    try {
      final cachedMap = await PersistentStorageHolder.read('_cachedCached');

      cachedMap.forEach((_, value) {
        if (value is! int) throw TypeError();
      });

      _cachedCached = cachedMap;
    } catch (e) {
      _cachedCached = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  late final Map<String, dynamic> _cachedCached;

  @override
  Future<int> get cached async {
    await _completerFuture;

    final cachedValue = _cachedCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cached;

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedCached[""] = toReturn;

      await PersistentStorageHolder.write('_cachedCached', _cachedCached);

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class PersistentCachedGetter {
  factory PersistentCachedGetter() = _PersistentCachedGetter;

  @PersistentCached()
  Future<int> get cached async {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$DirectPersistentCachedGetter {}

class _DirectPersistentCachedGetter
    with DirectPersistentCachedGetter
    implements _$DirectPersistentCachedGetter {
  _DirectPersistentCachedGetter();

  @override
  Future<int> get cached async {
    final cachedValue = await PersistentStorageHolder.read('_cachedCached');
    if (cachedValue.isEmpty && cachedValue[''] == null) {
      final int toReturn;
      try {
        final result = super.cached;

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      await PersistentStorageHolder.write('_cachedCached', {'': toReturn});

      return toReturn;
    } else {
      return cachedValue[''];
    }
  }
}
''',
)
@withCache
abstract class DirectPersistentCachedGetter {
  factory DirectPersistentCachedGetter() = _DirectPersistentCachedGetter;

  @DirectPersistentCached()
  Future<int> get cached async {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$LazyPersistentCachedGetter {}

class _LazyPersistentCachedGetter
    with LazyPersistentCachedGetter
    implements _$LazyPersistentCachedGetter {
  _LazyPersistentCachedGetter();

  Map<String, dynamic>? _cachedCached = null;

  @override
  Future<int> get cached async {
    if (_cachedCached == null) {
      try {
        final cachedMap = await PersistentStorageHolder.read('_cachedCached');

        cachedMap.forEach((_, value) {
          if (value is! int) throw TypeError();
        });

        _cachedCached = cachedMap;
      } catch (e) {
        _cachedCached = <String, dynamic>{};
      }
    }

    final cachedValue = _cachedCached![""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cached;

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedCached![""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class LazyPersistentCachedGetter {
  factory LazyPersistentCachedGetter() = _LazyPersistentCachedGetter;

  @LazyPersistentCached()
  Future<int> get cached async {
    return 1;
  }
}
