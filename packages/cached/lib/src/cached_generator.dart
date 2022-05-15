import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/config.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

class CachedGenerator extends GeneratorForAnnotation<WithCache> {
  const CachedGenerator({
    required this.config,
  });

  final Config config;

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'Annotation WithCache cannot target ${element.runtimeType}',
        element: element,
      );
    }

    final cachedClass = ClassWithCache.fromElement(element, config);

    return '';
  }
}
