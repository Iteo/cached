import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

abstract class CachedFunction {
  CachedFunction({
    required this.name,
    required this.syncWrite,
    required this.isAsync,
    required this.isGenerator,
    required this.returnType,
    this.limit,
    this.ttl,
  });

  final String name;
  final bool syncWrite;
  final String returnType;
  final bool isGenerator;
  final bool isAsync;
  final int? limit;
  final int? ttl;

  static void assertIsValid(ExecutableElement element) {
    assertMethodNotVoid(element);
    assertMethodIsNotAbstract(element);
  }

  static DartObject? getAnnotation(ExecutableElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(Cached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
