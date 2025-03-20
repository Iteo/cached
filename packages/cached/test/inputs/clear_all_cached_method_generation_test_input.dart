import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow(
  '[ERROR] Too many `clearAllCached` annotation, only one can be',
  element: false,
)
@withCache
abstract class MultipleClearAllMethods {
  factory MultipleClearAllMethods() = _MultipleClearAllMethods;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  void something();

  @clearAllCached
  void somethingTwo();
}

@ShouldThrow(
  '[ERROR] `something` must be a void or Future<void> method',
  element: false,
)
@withCache
abstract class InvalidReturnType {
  factory InvalidReturnType() = _InvalidReturnType;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  String something();
}

@ShouldThrow(
  '[ERROR] `something` return type must be a void, Future<void>, bool, '
  'Future<bool>',
  element: false,
)
@withCache
abstract class InvalidReturnTypeNonAbstract {
  factory InvalidReturnTypeNonAbstract() = _InvalidReturnTypeNonAbstract;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  String something() {
    return '';
  }
}

@ShouldThrow('[ERROR] `something` method cant have arguments')
@withCache
abstract class AbstractWithParams {
  factory AbstractWithParams() = _AbstractWithParams;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  void something(String a);
}

@ShouldGenerate(
  r'''
abstract class _$ValidAbstractWithTtl {}

class _ValidAbstractWithTtl
    with ValidAbstractWithTtl
    implements _$ValidAbstractWithTtl {
  _ValidAbstractWithTtl();

  final _cachedMethodCached = <String, int>{};

  final _cachedMethodTtl = <String, String>{};

  @override
  int cachedMethod() {
    final now = DateTime.now();
    final cachedTtl = _cachedMethodTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _cachedMethodTtl.remove("");
      _cachedMethodCached.remove("");
    }

    final cachedValue = _cachedMethodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedMethodCached[""] = toReturn;

      const duration = Duration(seconds: 30);
      _cachedMethodTtl[""] = DateTime.now().add(duration).toIso8601String();

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  void something() {
    _cachedMethodCached.clear();
    _cachedMethodTtl.clear();
  }
}
''',
)
@withCache
abstract class ValidAbstractWithTtl {
  factory ValidAbstractWithTtl() = _ValidAbstractWithTtl;

  @Cached(ttl: 30)
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  void something();
}

@ShouldGenerate(
  r'''
abstract class _$ValidAbstract {}

class _ValidAbstract with ValidAbstract implements _$ValidAbstract {
  _ValidAbstract();

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

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  void something() {
    _cachedMethodCached.clear();
  }
}
''',
)
@withCache
abstract class ValidAbstract {
  factory ValidAbstract() = _ValidAbstract;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  void something();
}

@ShouldGenerate(
  r'''
abstract class _$ValidAbstractFuture {}

class _ValidAbstractFuture
    with ValidAbstractFuture
    implements _$ValidAbstractFuture {
  _ValidAbstractFuture();

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

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<void> something() async {
    _cachedMethodCached.clear();
  }
}
''',
)
@withCache
abstract class ValidAbstractFuture {
  factory ValidAbstractFuture() = _ValidAbstractFuture;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  Future<void> something();
}

@ShouldGenerate(
  r'''
abstract class _$ValidReturnFutureBool {}

class _ValidReturnFutureBool
    with ValidReturnFutureBool
    implements _$ValidReturnFutureBool {
  _ValidReturnFutureBool();

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

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<bool> something() async {
    final bool toReturn;

    final result = super.something();
    toReturn = await result;

    if (toReturn) {
      _cachedMethodCached.clear();
    }

    return toReturn;
  }
}
''',
)
@withCache
abstract class ValidReturnFutureBool {
  factory ValidReturnFutureBool() = _ValidReturnFutureBool;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  Future<bool> something() {
    return true;
  }
}

@ShouldGenerate(
  r'''
abstract class _$ValidReturnFutureVoid {}

class _ValidReturnFutureVoid
    with ValidReturnFutureVoid
    implements _$ValidReturnFutureVoid {
  _ValidReturnFutureVoid();

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

      _cachedMethodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<void> something() async {
    await super.something();

    _cachedMethodCached.clear();
  }
}
''',
)
@withCache
abstract class ValidReturnFutureVoid {
  factory ValidReturnFutureVoid() = _ValidReturnFutureVoid;

  @cached
  int cachedMethod() {
    return 1;
  }

  @clearAllCached
  Future<void> something() async {}
}

@ShouldGenerate(
  r'''
abstract class _$ClearAllCachedDirectPersistentStorage {}

class _ClearAllCachedDirectPersistentStorage
    with ClearAllCachedDirectPersistentStorage
    implements _$ClearAllCachedDirectPersistentStorage {
  _ClearAllCachedDirectPersistentStorage();

  @override
  Future<int> cachedMethod() async {
    final cachedValue = await PersistentStorageHolder.read(
      '_cachedMethodCached',
    );
    if (cachedValue.isEmpty && cachedValue[''] == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      await PersistentStorageHolder.write('_cachedMethodCached', {
        '': toReturn,
      });

      return toReturn;
    } else {
      return cachedValue[''];
    }
  }

  @override
  Future<void> something() async {
    await super.something();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.deleteAll();
    }
  }
}
''',
)
@withCache
abstract class ClearAllCachedDirectPersistentStorage {
  factory ClearAllCachedDirectPersistentStorage() =
      _ClearAllCachedDirectPersistentStorage;

  @DirectPersistentCached()
  Future<int> cachedMethod() async {
    return Future.value(1);
  }

  @clearAllCached
  Future<void> something() async {}
}

@ShouldGenerate(r'''
abstract class _$ClearAllCachedDirectPersistentStorageAndPersistentStorage {}

class _ClearAllCachedDirectPersistentStorageAndPersistentStorage
    with ClearAllCachedDirectPersistentStorageAndPersistentStorage
    implements _$ClearAllCachedDirectPersistentStorageAndPersistentStorage {
  _ClearAllCachedDirectPersistentStorageAndPersistentStorage() {
    _init();
  }

  Future<void> _init() async {
    try {
      final cachedMap = await PersistentStorageHolder.read(
        '_cachedNotDirectMethodCached',
      );

      cachedMap.forEach((_, value) {
        if (value is! int) throw TypeError();
      });

      _cachedNotDirectMethodCached = cachedMap;
    } catch (e) {
      _cachedNotDirectMethodCached = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  late final Map<String, dynamic> _cachedNotDirectMethodCached;

  @override
  Future<int> cachedMethod() async {
    final cachedValue = await PersistentStorageHolder.read(
      '_cachedMethodCached',
    );
    if (cachedValue.isEmpty && cachedValue[''] == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      await PersistentStorageHolder.write('_cachedMethodCached', {
        '': toReturn,
      });

      return toReturn;
    } else {
      return cachedValue[''];
    }
  }

  @override
  Future<int> cachedNotDirectMethod() async {
    await _completerFuture;

    final cachedValue = _cachedNotDirectMethodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedNotDirectMethod();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedNotDirectMethodCached[""] = toReturn;

      await PersistentStorageHolder.write(
        '_cachedNotDirectMethodCached',
        _cachedNotDirectMethodCached,
      );

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<void> something() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.something();

    _cachedNotDirectMethodCached.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.deleteAll();
    }
  }
}
''')
@withCache
abstract class ClearAllCachedDirectPersistentStorageAndPersistentStorage {
  factory ClearAllCachedDirectPersistentStorageAndPersistentStorage() =
      _ClearAllCachedDirectPersistentStorageAndPersistentStorage;

  @DirectPersistentCached()
  Future<int> cachedMethod() async {
    return Future.value(1);
  }

  @PersistentCached()
  Future<int> cachedNotDirectMethod() async {
    return Future.value(1);
  }

  @clearAllCached
  Future<void> something() async {}
}
