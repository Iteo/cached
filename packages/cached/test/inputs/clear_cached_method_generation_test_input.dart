import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow(
  '''
Name of method for which cache should be cleared is not provider. 
Provide it trougth annotation parameter (`@ClearCached('methodName')`) 
or trougth clear function name e.g. `void clearMethodName();`
''',
)
@withCache
abstract class NoTargetMethod {
  factory NoTargetMethod() = _NoTargetMethod;

  @clearCached
  void something();
}

@ShouldThrow('[ERROR] No cache method for `something` method', element: false)
@withCache
abstract class InvalidName {
  factory InvalidName() = _InvalidName;

  @ClearCached('invalidName')
  void something();
}

@ShouldThrow('[ERROR] `something` must be a void method', element: false)
@withCache
abstract class InvalidReturnType {
  factory InvalidReturnType() = _InvalidReturnType;

  @cached
  int cachedMethod() {
    return 1;
  }

  @ClearCached('cachedMethod')
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

  @ClearCached('cachedMethod')
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

  @ClearCached('cachedMethod')
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

  @ClearCached('cachedMethod')
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

  @ClearCached('cachedMethod')
  void something();
}
