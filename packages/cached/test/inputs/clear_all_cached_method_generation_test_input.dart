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

@ShouldThrow('[ERROR] `something` must be a void method', element: false)
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
  '[ERROR] `something` return type must be a void, Future<void>, bool, Future<bool>',
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

  final _cachedMethodTtl = <String, DateTime>{};

  @override
  int cachedMethod() {
    final now = DateTime.now();
    final currentTtl = _cachedMethodTtl[""];

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

      _cachedMethodTtl[""] = DateTime.now().add(const Duration(seconds: 30));

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
