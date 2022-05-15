import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _defaultOnCacheOnError = false;

class IgnoreCacheAnnotation {
  const IgnoreCacheAnnotation({
    required this.useCacheOnError,
  });

  final bool useCacheOnError;
}

class Param {
  const Param({
    required this.name,
    required this.type,
    required this.isPositional,
    required this.isNamed,
    required this.isOptinal,
    this.ignoreCacheAnnotation,
    this.defaultValue,
  });

  final String name;
  final String type;
  final String? defaultValue;
  final bool isPositional;
  final bool isNamed;
  final bool isOptinal;
  final IgnoreCacheAnnotation? ignoreCacheAnnotation;

  factory Param.fromElement(ParameterElement element, Config config) {
    const paramAnnotationChecker = TypeChecker.fromRuntime(IgnoreCache);
    final annotation = paramAnnotationChecker.firstAnnotationOf(element);

    IgnoreCacheAnnotation? annotationData;
    if (annotation != null) {
      annotationData = IgnoreCacheAnnotation(
        useCacheOnError: config.onCacheOnError ?? _defaultOnCacheOnError,
      );

      final reader = ConstantReader(annotation);
      final useCacheOnErrorField = reader.read('useCacheOnError');
      if (useCacheOnErrorField.isBool) {
        annotationData = IgnoreCacheAnnotation(
          useCacheOnError: useCacheOnErrorField.boolValue,
        );
      }
    }
    
    return Param(
      name: element.name,
      type: element.type.getDisplayString(withNullability: true),
      isPositional: element.isPositional,
      isNamed: element.isNamed,
      isOptinal: element.isOptional,
      ignoreCacheAnnotation: annotationData,
      defaultValue: element.defaultValueCode,
    );
  }

  String get typeWithName => '$type $name';
}
