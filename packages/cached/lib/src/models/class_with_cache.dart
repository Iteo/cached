import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/constructor.dart';
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
    this.clearAllMethod,
  });

  final bool useStaticCache;
  final String name;
  final Constructor constructor;
  final Iterable<CachedMethod> methods;
  final Iterable<ClearCachedMethod> clearMethods;
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
        if (method.ttl != null)
          method.name
    };

    final clearMethods = element.methods
        .where((element) => ClearCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map((e) => ClearCachedMethod.fromElement(e, config,methodsWithTtls));

    assertValidateClearCachedMethods(clearMethods, methods);

    final clearAllMethod = element.methods
        .where((element) => ClearAllCachedMethod.getAnnotation(element) != null)
        .inspect(assertCorrectClearMethodType)
        .map((e) => ClearAllCachedMethod.fromElement(e, config, methodsWithTtls));

    assertOneClearAllCachedAnnotation(clearAllMethod);

    return ClassWithCache(
      name: element.name,
      useStaticCache:
          useStaticCache ?? config.useStaticCache ?? _defaultUseStaticCache,
      methods: methods,
      clearMethods: clearMethods,
      constructor: constructor,
      clearAllMethod: clearAllMethod.firstOrNull,
    );
  }
}
