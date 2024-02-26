import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/constructor.dart';
import 'package:cached/src/models/deletes_cache_method.dart';
import 'package:cached/src/models/getters/cached_getter.dart';
import 'package:cached/src/models/getters/lazy_persistent_cached_getter.dart';
import 'package:cached/src/models/getters/persistent_cached_getter.dart';
import 'package:cached/src/models/lazy_persistent_cached_method.dart';
import 'package:cached/src/models/persistent_cached_method.dart';
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
    required this.getters,
    this.clearAllMethod,
  });

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

    final lazyPersistentMethods = element.methods
        .where(CachedFunction.hasCachedAnnotation<LazyPersistentCached>)
        .map((e) => LazyPersistentCachedMethod.fromElement(e, config));

    final persistentMethods = element.methods
        .where(CachedFunction.hasCachedAnnotation<PersistentCached>)
        .where(
          (element) =>
              lazyPersistentMethods.none((e) => e.name == element.name),
        )
        .map((e) => PersistentCachedMethod.fromElement(e, config));

    final cachedMethods = element.methods
        .where(CachedFunction.hasCachedAnnotation<Cached>)
        .where(
          (element) =>
              persistentMethods.none((e) => e.name == element.name) &&
              lazyPersistentMethods.none((e) => e.name == element.name),
        )
        .map((e) => CachedMethod<Cached>.fromElement(e, config));

    final methods = [
      ...cachedMethods,
      ...persistentMethods,
      ...lazyPersistentMethods,
    ];

    final methodsWithTtls = methods
        .where((method) => method.ttl != null)
        .map((method) => method.name);

    final lazyPersistentGetters = element.accessors
        .where((element) => element.isGetter)
        .where(CachedFunction.hasCachedAnnotation<LazyPersistentCached>)
        .map((e) => LazyPersistentCachedGetter.fromElement(e, config));

    final persistentGetters = element.accessors
        .where((element) => element.isGetter)
        .where(CachedFunction.hasCachedAnnotation<PersistentCached>)
        .where(
          (element) =>
              lazyPersistentMethods.none((e) => e.name == element.name),
        )
        .map((e) => PersistentCachedGetter.fromElement(e, config));

    final cachedGetters = element.accessors
        .where((element) => element.isGetter)
        .where(
          (element) =>
              CachedFunction.hasCachedAnnotation<Cached>(element) &&
              persistentMethods.none((e) => e.name == element.name) &&
              lazyPersistentMethods.none((e) => e.name == element.name),
        )
        .map((e) => CachedGetter<Cached>.fromElement(e, config));

    final getters = [
      ...cachedGetters,
      ...persistentGetters,
      ...lazyPersistentGetters,
    ];

    final gettersWithTtls = getters
        .where((getter) => getter.ttl != null)
        .map((getter) => getter.name);

    final clearMethods = element.methods
        .where((element) => ClearCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map(
          (e) => ClearCachedMethod.fromElement(
            e,
            config,
            <String>{...methodsWithTtls, ...gettersWithTtls},
          ),
        );

    assertValidateClearCachedMethods(clearMethods, methods, getters);

    final clearAllMethod = element.methods
        .where((element) => ClearAllCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map(
          (e) => ClearAllCachedMethod.fromElement(
            e,
            config,
            <String>{...methodsWithTtls, ...gettersWithTtls},
          ),
        );

    assertOneClearAllCachedAnnotation(clearAllMethod);

    final streamedCacheMethods = element.methods
        .where((element) => StreamedCacheMethod.getAnnotation(element) != null)
        .inspect(assertCorrectStreamMethodType)
        .map(
          (e) => StreamedCacheMethod.fromElement(
            e,
            [...element.methods, ...element.accessors],
            config,
          ),
        )
        .toList();

    assertOneCacheStreamPerCachedMethod(
      [...element.methods, ...element.accessors],
      streamedCacheMethods,
    );

    final cachePeekMethods = element.methods
        .where((element) => CachePeekMethod.getAnnotation(element) != null)
        .inspect(assertCorrectCachePeekMethodType)
        .map(
          (e) => CachePeekMethod.fromElement(
            e,
            [...element.methods, ...element.accessors],
            config,
          ),
        )
        .toList();

    assertOneCachePeekPerCachedMethod(
      [...element.methods, ...element.accessors],
      cachePeekMethods,
    );

    final deletesCacheMethods = element.methods
        .where((element) => DeletesCacheMethod.getAnnotation(element) != null)
        .inspect(assertCorrectDeletesCacheMethodType)
        .map(
          (e) => DeletesCacheMethod.fromElement(
            e,
            config,
            <String>{...methodsWithTtls, ...gettersWithTtls},
          ),
        )
        .toList();

    assertValidateDeletesCacheMethods(
      deletesCacheMethods,
      [...methods, ...getters],
    );

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
      getters: getters,
    );
  }

  final bool useStaticCache;
  final String name;
  final Constructor constructor;
  final Iterable<CachedMethod> methods;
  final Iterable<ClearCachedMethod> clearMethods;
  final Iterable<StreamedCacheMethod> streamedCacheMethods;
  final Iterable<CachePeekMethod> cachePeekMethods;
  final Iterable<DeletesCacheMethod> deletesCacheMethods;
  final ClearAllCachedMethod? clearAllMethod;
  final Iterable<CachedGetter> getters;
}
