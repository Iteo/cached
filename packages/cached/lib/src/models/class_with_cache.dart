import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/asserts.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/constructor.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _defaultUseStaticCache = false;

class ClassWithCache {
  const ClassWithCache({
    required this.name,
    required this.useStaticCache,
    required this.methods,
    required this.constructor,
    required this.clearMethods,
  });

  final bool useStaticCache;
  final String name;
  final Constructor constructor;
  final Iterable<CachedMethod> methods;
  final Iterable<ClearCachedMethod> clearMethods;

  factory ClassWithCache.fromElement(ClassElement element, Config config) {
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

    assertOneConstFactoryConstructor(element);
    final constructor = element.constructors.map((element) => Constructor.fromElement(element, config)).first;

    final methods = element.methods
        .where(
          (element) => !element.isAbstract && !element.isSynthetic && CachedMethod.getAnnotation(element) != null,
        )
        .map((e) => CachedMethod.fromElement(e, config));

    final clearMethods = element.methods
        .where(
          (element) =>
              element.isAbstract &&
              !element.isAsynchronous &&
              element.returnType.isVoid &&
              ClearCachedMethod.getAnnotation(element) != null,
        )
        .map((e) => ClearCachedMethod.fromElement(e));

    assertValidateClearCachedMethods(clearMethods, methods);

    return ClassWithCache(
      name: element.name,
      useStaticCache: useStaticCache ?? config.useStaticCache ?? _defaultUseStaticCache,
      methods: methods,
      clearMethods: clearMethods,
      constructor: constructor,
    );
  }
}
