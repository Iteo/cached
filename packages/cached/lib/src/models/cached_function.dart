import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/models/check_if_should_cache_method.dart';
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
    required this.limit,
    required this.ttl,
    required this.checkIfShouldCacheMethod,
    required this.persistentStorage,
    required this.lazyPersistentStorage,
  });

  final String name;
  final bool syncWrite;
  final String returnType;
  final bool isGenerator;
  final bool isAsync;
  final int? limit;
  final int? ttl;
  final CheckIfShouldCacheMethod? checkIfShouldCacheMethod;
  final bool? persistentStorage;
  final bool? lazyPersistentStorage;

  static void assertIsValid(ExecutableElement element) {
    assertMethodNotVoid(element);
    assertMethodIsNotAbstract(element);
  }

  static DartObject? getAnnotation<T extends Cached>(
    ExecutableElement element,
  ) {
    final methodAnnotationChecker = TypeChecker.fromRuntime(T);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }

  static bool hasCachedAnnotation<T extends Cached>(ExecutableElement element) {
    return getAnnotation<T>(element) != null;
  }
}
