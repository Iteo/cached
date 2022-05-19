import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow('Method method returns void or Future<void> which is not allowed')
@withCache
abstract class VoidMethod {
  factory VoidMethod() = _VoidMethod;

  @cached
  void method() {}
}

@ShouldThrow('Method method returns void or Future<void> which is not allowed')
@withCache
abstract class FutureVoidMethod {
  factory FutureVoidMethod() = _FutureVoidMethod;

  @cached
  Future<void> method() async {}
}

@ShouldThrow('Cached method method is abstract which is not allowed')
@withCache
abstract class AbstractMethod {
  factory AbstractMethod() = _AbstractMethod;

  @cached
  Future<int> method();
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithNoArguments {}

class _MethodWithNoArguments
    with MethodWithNoArguments
    implements _$MethodWithNoArguments {
  _MethodWithNoArguments();

  final _methodCached = <String, int>{};

  @override
  int method() {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class MethodWithNoArguments {
  factory MethodWithNoArguments() = _MethodWithNoArguments;

  @cached
  int method() {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncMethodWithNoArguments {}

class _AsyncMethodWithNoArguments
    with AsyncMethodWithNoArguments
    implements _$AsyncMethodWithNoArguments {
  _AsyncMethodWithNoArguments();

  final _methodCached = <String, int>{};

  @override
  Future<int> method() async {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class AsyncMethodWithNoArguments {
  factory AsyncMethodWithNoArguments() = _AsyncMethodWithNoArguments;

  @cached
  Future<int> method() {
    return Future.value(1);
  }
}

@ShouldGenerate(
  r'''
abstract class _$AsyncGeneratorMethodWithNoArguments {}

class _AsyncGeneratorMethodWithNoArguments
    with AsyncGeneratorMethodWithNoArguments
    implements _$AsyncGeneratorMethodWithNoArguments {
  _AsyncGeneratorMethodWithNoArguments();

  final _methodCached = <String, Stream<int>>{};

  @override
  Stream<int> method() async* {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final Stream<int> toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      yield* toReturn;
    } else {
      yield* cachedValue;
    }
  }
}
''',
)
@withCache
abstract class AsyncGeneratorMethodWithNoArguments {
  factory AsyncGeneratorMethodWithNoArguments() =
      _AsyncGeneratorMethodWithNoArguments;

  @cached
  Stream<int> method() async* {
    yield 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$SyncGeneratorMethodWithNoArguments {}

class _SyncGeneratorMethodWithNoArguments
    with SyncGeneratorMethodWithNoArguments
    implements _$SyncGeneratorMethodWithNoArguments {
  _SyncGeneratorMethodWithNoArguments();

  final _methodCached = <String, Iterable<int>>{};

  @override
  Iterable<int> method() sync* {
    final cachedValue = _methodCached[""];
    if (cachedValue == null) {
      final Iterable<int> toReturn;
      try {
        final result = super.method();

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[""] = toReturn;

      yield* toReturn;
    } else {
      yield* cachedValue;
    }
  }
}
''',
)
@withCache
abstract class SyncGeneratorMethodWithNoArguments {
  factory SyncGeneratorMethodWithNoArguments() =
      _SyncGeneratorMethodWithNoArguments;

  @cached
  Iterable<int> method() sync* {
    yield 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithPositionalArgs {}

class _MethodWithPositionalArgs
    with MethodWithPositionalArgs
    implements _$MethodWithPositionalArgs {
  _MethodWithPositionalArgs();

  final _methodCached = <String, int>{};

  @override
  int method(int a, String? b, Stream<double> c) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class MethodWithPositionalArgs {
  factory MethodWithPositionalArgs() = _MethodWithPositionalArgs;

  @cached
  int method(int a, String? b, Stream<double> c) {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithOptionalArgs {}

class _MethodWithOptionalArgs
    with MethodWithOptionalArgs
    implements _$MethodWithOptionalArgs {
  _MethodWithOptionalArgs();

  final _methodCached = <String, int>{};

  @override
  int method([int a = 1, String? b, Stream<double>? c, double? d = 0.2]) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c, d);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class MethodWithOptionalArgs {
  factory MethodWithOptionalArgs() = _MethodWithOptionalArgs;

  @cached
  int method([int a = 1, String? b, Stream<double>? c, double? d = 0.2]) {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithNamedArgs {}

class _MethodWithNamedArgs
    with MethodWithNamedArgs
    implements _$MethodWithNamedArgs {
  _MethodWithNamedArgs();

  final _methodCached = <String, int>{};

  @override
  int method(
      {required int a,
      required String? b,
      Stream<double>? c,
      double? d = 0.2}) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a: a, b: b, c: c, d: d);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class MethodWithNamedArgs {
  factory MethodWithNamedArgs() = _MethodWithNamedArgs;

  @cached
  int method({
    required int a,
    required String? b,
    Stream<double>? c,
    double? d = 0.2,
  }) {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithPositionalAndOptionalArgs {}

class _MethodWithPositionalAndOptionalArgs
    with MethodWithPositionalAndOptionalArgs
    implements _$MethodWithPositionalAndOptionalArgs {
  _MethodWithPositionalAndOptionalArgs();

  final _methodCached = <String, int>{};

  @override
  int method(int a, String? b, [Stream<double>? c, double? d = 0.2]) {
    final cachedValue =
        _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c, d);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached["${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class MethodWithPositionalAndOptionalArgs {
  factory MethodWithPositionalAndOptionalArgs() =
      _MethodWithPositionalAndOptionalArgs;

  @cached
  int method(
    int a,
    String? b, [
    Stream<double>? c,
    double? d = 0.2,
  ]) {
    return 1;
  }
}

@ShouldGenerate(
  r'''
abstract class _$MethodWithPositionalAndNamedArgs {}

class _MethodWithPositionalAndNamedArgs
    with MethodWithPositionalAndNamedArgs
    implements _$MethodWithPositionalAndNamedArgs {
  _MethodWithPositionalAndNamedArgs();

  final _methodCached = <String, int>{};

  @override
  int method(int a, String? b,
      {required Stream<double>? c,
      double? d = 0.2,
      required String e,
      int f = 1}) {
    final cachedValue = _methodCached[
        "${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}${e.hashCode}${f.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.method(a, b, c: c, d: d, e: e, f: f);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _methodCached[
              "${a.hashCode}${b.hashCode}${c.hashCode}${d.hashCode}${e.hashCode}${f.hashCode}"] =
          toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''',
)
@withCache
abstract class MethodWithPositionalAndNamedArgs {
  factory MethodWithPositionalAndNamedArgs() =
      _MethodWithPositionalAndNamedArgs;

  @cached
  int method(
    int a,
    String? b, {
    required Stream<double>? c,
    double? d = 0.2,
    required String e,
    int f = 1,
  }) {
    return 1;
  }
}
