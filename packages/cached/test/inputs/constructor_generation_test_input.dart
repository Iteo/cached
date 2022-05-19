import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

@ShouldGenerate(
  r'''
abstract class _$PositionalArguments {
  int get a;
  String? get b;
  Stream<double>? get c;
}

class _PositionalArguments
    with PositionalArguments
    implements _$PositionalArguments {
  _PositionalArguments(this.a, this.b, this.c);

  @override
  final int a;
  @override
  final String? b;
  @override
  final Stream<double>? c;
}
''',
)
@withCache
abstract class PositionalArguments implements _$PositionalArguments {
  factory PositionalArguments(
    int a,
    String? b,
    Stream<double>? c,
  ) = _PositionalArguments;
}

@ShouldGenerate(
  r'''
abstract class _$OptionalArguments {
  String? get b;
  Stream<double>? get c;
}

class _OptionalArguments with OptionalArguments implements _$OptionalArguments {
  _OptionalArguments([this.b, this.c]);

  @override
  final String? b;
  @override
  final Stream<double>? c;
}
''',
)
@withCache
abstract class OptionalArguments implements _$OptionalArguments {
  factory OptionalArguments([
    String? b,
    Stream<double>? c,
  ]) = _OptionalArguments;
}

@ShouldGenerate(
  r'''
abstract class _$NamedArguments {
  int get a;
  String? get b;
  Stream<double>? get c;
}

class _NamedArguments with NamedArguments implements _$NamedArguments {
  _NamedArguments({required this.a, this.b, required this.c});

  @override
  final int a;
  @override
  final String? b;
  @override
  final Stream<double>? c;
}
''',
)
@withCache
abstract class NamedArguments implements _$NamedArguments {
  factory NamedArguments({
    required int a,
    String? b,
    required Stream<double>? c,
  }) = _NamedArguments;
}

@ShouldGenerate(
  r'''
abstract class _$PositionalAndOptinalArguments {
  int get a;
  String? get b;
  Stream<double>? get c;
}

class _PositionalAndOptinalArguments
    with PositionalAndOptinalArguments
    implements _$PositionalAndOptinalArguments {
  _PositionalAndOptinalArguments(this.a, this.b, [this.c]);

  @override
  final int a;
  @override
  final String? b;
  @override
  final Stream<double>? c;
}
''',
)
@withCache
abstract class PositionalAndOptinalArguments
    implements _$PositionalAndOptinalArguments {
  factory PositionalAndOptinalArguments(
    int a,
    String? b, [
    Stream<double>? c,
  ]) = _PositionalAndOptinalArguments;
}

@ShouldGenerate(
  r'''
abstract class _$PositionalAndNamesArguments {
  int get a;
  String? get b;
  Stream<double>? get c;
  double get d;
}

class _PositionalAndNamesArguments
    with PositionalAndNamesArguments
    implements _$PositionalAndNamesArguments {
  _PositionalAndNamesArguments(this.a, this.b, {this.c, required this.d});

  @override
  final int a;
  @override
  final String? b;
  @override
  final Stream<double>? c;
  @override
  final double d;
}
''',
)
@withCache
abstract class PositionalAndNamesArguments
    implements _$PositionalAndNamesArguments {
  factory PositionalAndNamesArguments(
    int a,
    String? b, {
    Stream<double>? c,
    required double d,
  }) = _PositionalAndNamesArguments;
}
