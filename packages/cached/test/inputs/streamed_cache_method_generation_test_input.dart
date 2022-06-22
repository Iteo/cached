import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow(
    '[ERROR] Streamed cache method return type needs to be a Stream<int>')
@withCache
abstract class StreamedCacheMethodReturnType {
  factory StreamedCacheMethodReturnType() = _StreamedCacheMethodReturnType;

  @cached
  int cachedMethod() {
    return 1;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  int cachedStream();
}

@ShouldThrow('[ERROR] Method "totallyWrongName" do not exists')
@withCache
abstract class MethodShouldExists {
  factory MethodShouldExists() = _MethodShouldExists;

  @cached
  int cachedMethod() {
    return 1;
  }

  @StreamedCache(methodName: "totallyWrongName", emitLastValue: false)
  Stream<int> cachedStream();
}

@ShouldThrow('[ERROR] Method "cachedMethod" do not have @cached annotation')
@withCache
abstract class MethodShouldHaveCachedAnnotation {
  factory MethodShouldHaveCachedAnnotation() =
      _MethodShouldHaveCachedAnnotation;

  int cachedMethod() {
    return 1;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream();
}

@ShouldThrow(
    '[ERROR] Streamed cache method return type needs to be a Stream<int>')
@withCache
abstract class MethodShouldHaveSyncReturnTypeInStream {
  factory MethodShouldHaveSyncReturnTypeInStream() =
      _MethodShouldHaveSyncReturnTypeInStream;

  @cached
  Future<int> cachedMethod() {
    return 1;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<Future<int>> cachedStream();
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedStream", excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParams {
  factory MethodShouldHaveSameParams() = _MethodShouldHaveSameParams;

  @cached
  Future<int> cachedMethod(String x, double y) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(int z);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedStream", excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsNullable {
  factory MethodShouldHaveSameParamsNullable() =
      _MethodShouldHaveSameParamsNullable;

  @cached
  Future<int> cachedMethod(int? z) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(int z);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedStream", excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsNoParams {
  factory MethodShouldHaveSameParamsNoParams() =
      _MethodShouldHaveSameParamsNoParams;

  @cached
  Future<int> cachedMethod() {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(int z);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedStream", excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsWithoutIgnore {
  factory MethodShouldHaveSameParamsWithoutIgnore() =
      _MethodShouldHaveSameParamsWithoutIgnore;

  @cached
  Future<int> cachedMethod(@ignore int x) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(int x);
}

@ShouldThrow(
    '[ERROR] Method "cachedMethod" should have same parameters as "cachedStream", excluding ones marked with @ignore and @ignoreCache')
@withCache
abstract class MethodShouldHaveSameParamsWithoutIgnoreCache {
  factory MethodShouldHaveSameParamsWithoutIgnoreCache() =
      _MethodShouldHaveSameParamsWithoutIgnoreCache;

  @cached
  Future<int> cachedMethod(int x, @ignoreCache bool ignoreCache) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(int x, bool ignoreCache);
}

@ShouldGenerate(r'''
abstract class _$SimpleMethod {}

class _SimpleMethod with SimpleMethod implements _$SimpleMethod {
  _SimpleMethod();

  final _cachedMethodCached = <String, int>{};

  final _cachedMethodCacheStream = <String, StreamController<int>>{};

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

      final streamController = _cachedMethodCacheStream[""];
      if (streamController != null) {
        streamController.sink.add(toReturn);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Stream<int> cachedStream() {
    final paramsKey = "";
    final streamController = _cachedMethodCacheStream[paramsKey];

    if (streamController == null) {
      final newStreamController = StreamController<int>.broadcast();
      _cachedMethodCacheStream[paramsKey] = newStreamController;

      final returnStream = StreamController<int>();

      returnStream.sink.addStream(newStreamController.stream);

      return returnStream.stream;
    } else {
      final returnStream = StreamController<int>();

      returnStream.sink.addStream(streamController.stream);

      return returnStream.stream;
    }
  }
}
''')
@withCache
abstract class SimpleMethod {
  factory SimpleMethod() = _SimpleMethod;

  @cached
  int cachedMethod() {
    return 1;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream();
}

@ShouldGenerate(r'''
abstract class _$FutureMethod {}

class _FutureMethod with FutureMethod implements _$FutureMethod {
  _FutureMethod();

  final _cachedMethodCached = <String, int>{};

  final _cachedMethodCacheStream = <String, StreamController<int>>{};

  @override
  Future<int> cachedMethod() async {
    final cachedValue = _cachedMethodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.cachedMethod();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _cachedMethodCached[""] = toReturn;

      final streamController = _cachedMethodCacheStream[""];
      if (streamController != null) {
        streamController.sink.add(toReturn);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Stream<int> cachedStream() {
    final paramsKey = "";
    final streamController = _cachedMethodCacheStream[paramsKey];

    if (streamController == null) {
      final newStreamController = StreamController<int>.broadcast();
      _cachedMethodCacheStream[paramsKey] = newStreamController;

      final returnStream = StreamController<int>();

      returnStream.sink.addStream(newStreamController.stream);

      return returnStream.stream;
    } else {
      final returnStream = StreamController<int>();

      returnStream.sink.addStream(streamController.stream);

      return returnStream.stream;
    }
  }
}
''')
@withCache
abstract class FutureMethod {
  factory FutureMethod() = _FutureMethod;

  @cached
  Future<int> cachedMethod() {
    return 1;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream();
}

@ShouldGenerate(r'''
abstract class _$EmitLastValue {}

class _EmitLastValue with EmitLastValue implements _$EmitLastValue {
  _EmitLastValue();

  final _cachedMethodCached = <String, int>{};

  final _cachedMethodCacheStream = <String, StreamController<int>>{};

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

      final streamController = _cachedMethodCacheStream[""];
      if (streamController != null) {
        streamController.sink.add(toReturn);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Stream<int> cachedStream() {
    final paramsKey = "";
    final streamController = _cachedMethodCacheStream[paramsKey];
    final lastValue = _cachedMethodCached[paramsKey];

    if (streamController == null) {
      final newStreamController = StreamController<int>.broadcast();
      _cachedMethodCacheStream[paramsKey] = newStreamController;

      final returnStream = StreamController<int>();
      if (lastValue != null) {
        returnStream.sink.add(lastValue);
      }

      returnStream.sink.addStream(newStreamController.stream);

      return returnStream.stream;
    } else {
      final returnStream = StreamController<int>();
      if (lastValue != null) {
        returnStream.sink.add(lastValue);
      }

      returnStream.sink.addStream(streamController.stream);

      return returnStream.stream;
    }
  }
}
''')
@withCache
abstract class EmitLastValue {
  factory EmitLastValue() = _EmitLastValue;

  @cached
  int cachedMethod() {
    return 1;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: true)
  Stream<int> cachedStream();
}

@ShouldGenerate(r'''
abstract class _$Parameters {}

class _Parameters with Parameters implements _$Parameters {
  _Parameters();

  final _cachedMethodCached = <String, int>{};

  final _cachedMethodCacheStream = <String, StreamController<int>>{};

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

      _cachedMethodCached["${y.hashCode}"] = toReturn;

      final streamController = _cachedMethodCacheStream["${y.hashCode}"];
      if (streamController != null) {
        streamController.sink.add(toReturn);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Stream<int> cachedStream(String y) {
    final paramsKey = "${y.hashCode}";
    final streamController = _cachedMethodCacheStream[paramsKey];

    if (streamController == null) {
      final newStreamController = StreamController<int>.broadcast();
      _cachedMethodCacheStream[paramsKey] = newStreamController;

      final returnStream = StreamController<int>();

      returnStream.sink.addStream(newStreamController.stream);

      return returnStream.stream;
    } else {
      final returnStream = StreamController<int>();

      returnStream.sink.addStream(streamController.stream);

      return returnStream.stream;
    }
  }
}
''')
@withCache
abstract class Parameters {
  factory Parameters() = _Parameters;

  @cached
  int cachedMethod(@ignore int x, String y) {
    return 1;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(String y);
}

@ShouldThrow(
    '[ERROR] `cachedMethod` cannot be targeted by multiple @StreamedCache methods')
@withCache
abstract class DuplicateTarget {
  factory DuplicateTarget() = _DuplicateTarget;

  @cached
  Future<int> cachedMethod(int x) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(int x);

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> anotherSameCacheStream(int x);
}

@ShouldThrow('[ERROR] `cachedStream` must be a abstract method')
@withCache
abstract class ShouldBeAbstract {
  factory ShouldBeAbstract() = _ShouldBeAbstract;

  @cached
  Future<int> cachedMethod(int x) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int> cachedStream(int x) => StreamController<int>().stream;
}

@ShouldGenerate(r'''
abstract class _$NullableReturnType {}

class _NullableReturnType
    with NullableReturnType
    implements _$NullableReturnType {
  _NullableReturnType();

  final _cachedMethodCached = <String, int?>{};

  final _cachedMethodCacheStream = <String, StreamController<int?>>{};

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

      _cachedMethodCached["${x.hashCode}"] = toReturn;

      final streamController = _cachedMethodCacheStream["${x.hashCode}"];
      if (streamController != null) {
        streamController.sink.add(toReturn);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Stream<int?> cachedStream(int x) {
    final paramsKey = "${x.hashCode}";
    final streamController = _cachedMethodCacheStream[paramsKey];

    if (streamController == null) {
      final newStreamController = StreamController<int?>.broadcast();
      _cachedMethodCacheStream[paramsKey] = newStreamController;

      final returnStream = StreamController<int?>();

      returnStream.sink.addStream(newStreamController.stream);

      return returnStream.stream;
    } else {
      final returnStream = StreamController<int?>();

      returnStream.sink.addStream(streamController.stream);

      return returnStream.stream;
    }
  }
}
''')
@withCache
abstract class NullableReturnType {
  factory NullableReturnType() = _NullableReturnType;

  @cached
  Future<int?> cachedMethod(int x) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: false)
  Stream<int?> cachedStream(int x);
}

@ShouldGenerate(r'''
abstract class _$NullableReturnTypeWithLastValue {}

class _NullableReturnTypeWithLastValue
    with NullableReturnTypeWithLastValue
    implements _$NullableReturnTypeWithLastValue {
  _NullableReturnTypeWithLastValue();

  final _cachedMethodCached = <String, int?>{};

  final _cachedMethodCacheStream = <String, StreamController<int?>>{};

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

      _cachedMethodCached["${x.hashCode}"] = toReturn;

      final streamController = _cachedMethodCacheStream["${x.hashCode}"];
      if (streamController != null) {
        streamController.sink.add(toReturn);
      }

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Stream<int?> cachedStream(int x) {
    final paramsKey = "${x.hashCode}";
    final streamController = _cachedMethodCacheStream[paramsKey];
    final lastValue = _cachedMethodCached[paramsKey];

    if (streamController == null) {
      final newStreamController = StreamController<int?>.broadcast();
      _cachedMethodCacheStream[paramsKey] = newStreamController;

      final returnStream = StreamController<int?>();
      returnStream.sink.add(lastValue);
      returnStream.sink.addStream(newStreamController.stream);

      return returnStream.stream;
    } else {
      final returnStream = StreamController<int?>();
      returnStream.sink.add(lastValue);
      returnStream.sink.addStream(streamController.stream);

      return returnStream.stream;
    }
  }
}
''')
@withCache
abstract class NullableReturnTypeWithLastValue {
  factory NullableReturnTypeWithLastValue() = _NullableReturnTypeWithLastValue;

  @cached
  Future<int?> cachedMethod(int x) {
    return y;
  }

  @StreamedCache(methodName: "cachedMethod", emitLastValue: true)
  Stream<int?> cachedStream(int x);
}
