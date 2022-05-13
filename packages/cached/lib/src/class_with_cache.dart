import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/cached_method.dart';
import 'package:cached/src/config.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _defaultUseStaticCache = false;

class ClassWithCache {
  const ClassWithCache({
    required this.name,
    required this.useStaticCache,
    required this.methods,
  });

  final bool useStaticCache;
  final String name;
  final Iterable<CachedMethod> methods;

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

    return ClassWithCache(
      name: element.name,
      useStaticCache:
          useStaticCache ?? config.useStaticCache ?? _defaultUseStaticCache,
      methods: element.methods
          .where(
            (element) =>
                !element.isAbstract &&
                !element.isSynthetic &&
                CachedMethod.getAnnotation(element) != null,
          )
          .map((e) => CachedMethod.fromElement(e, config)),
    );
  }
}
