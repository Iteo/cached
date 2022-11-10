import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/constructor.dart';
import 'package:cached/src/models/deletes_cache_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

const _defaultUseStaticCache = false;

class ClassWithCache {
  const ClassWithCache({
    required this.name,
    required this.useStaticCache,
    required this.methods,
    required this.constructor,
    required this.clearMethods,
    required this.streamedCacheMethods,
    required this.cachePeekMethods,
    required this.deletesCacheMethods,
    this.clearAllMethod,
  });

  final bool useStaticCache;
  final String name;
  final Constructor constructor;
  final Iterable<CachedMethod> methods;
  final Iterable<ClearCachedMethod> clearMethods;
  final Iterable<StreamedCacheMethod> streamedCacheMethods;
  final Iterable<CachePeekMethod> cachePeekMethods;
  final Iterable<DeletesCacheMethod> deletesCacheMethods;
  final ClearAllCachedMethod? clearAllMethod;

  factory ClassWithCache.fromElement(ClassElement element, Config config) {
    assertAbstract(element);
    assertOneConstFactoryConstructor(element);

    const classAnnotationChecker = TypeChecker.fromRuntime(WithCache);
    final annotation = classAnnotationChecker.firstAnnotationOf(element);

    bool? useStaticCache;

    if (annotation != null) {
      final reader = ConstantReader(annotation);
      final useStaticCacheField = reader.read('useStaticCache');
      if (useStaticCacheField.isBool) {
        useStaticCache = useStaticCacheField.boolValue;
      }
    }

    final constructor = element.constructors
        .map((element) => Constructor.fromElement(element, config))
        .first;

    final methods = element.methods
        .where(
          (element) => CachedMethod.getAnnotation(element) != null,
        )
        .map((e) => CachedMethod.fromElement(e, config));

    final methodsWithTtls = {
      for (final method in methods)
        if (method.ttl != null) method.name
    };

    final clearMethods = element.methods
        .where((element) => ClearCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map((e) => ClearCachedMethod.fromElement(e, config, methodsWithTtls));

    assertValidateClearCachedMethods(clearMethods, methods);

    final clearAllMethod = element.methods
        .where((element) => ClearAllCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map(
          (e) => ClearAllCachedMethod.fromElement(e, config, methodsWithTtls),
        );

    assertOneClearAllCachedAnnotation(clearAllMethod);

    final streamedCacheMethods = element.methods
        .where((element) => StreamedCacheMethod.getAnnotation(element) != null)
        .inspect(assertCorrectStreamMethodType)
        .map(
          (e) => StreamedCacheMethod.fromElement(
            e,
            element.methods,
            config,
          ),
        )
        .toList();

    assertOneCacheStreamPerCachedMethod(element.methods, streamedCacheMethods);

    final cachePeekMethods = element.methods
        .where((element) => CachePeekMethod.getAnnotation(element) != null)
        .inspect(assertCorrectCachePeekMethodType)
        .map(
          (e) => CachePeekMethod.fromElement(
            e,
            element.methods,
            config,
          ),
        )
        .toList();

    assertOneCachePeekPerCachedMethod(element.methods, cachePeekMethods);

    final deletesCacheMethods = element.methods
        .where((element) => DeletesCacheMethod.getAnnotation(element) != null)
        .inspect(assertCorrectDeletesCacheMethodType)
        .map(
          (e) => DeletesCacheMethod.fromElement(
            e,
            config,
            methodsWithTtls,
          ),
        )
        .toList();

    assertValidateDeletesCacheMethods(deletesCacheMethods, methods);

    return ClassWithCache(
      name: element.name,
      useStaticCache:
          useStaticCache ?? config.useStaticCache ?? _defaultUseStaticCache,
      methods: methods,
      clearMethods: clearMethods,
      streamedCacheMethods: streamedCacheMethods,
      constructor: constructor,
      clearAllMethod: clearAllMethod.firstOrNull,
      cachePeekMethods: cachePeekMethods,
      deletesCacheMethods: deletesCacheMethods,
    );
  }
}
