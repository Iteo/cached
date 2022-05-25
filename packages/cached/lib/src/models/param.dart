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
    required this.isNamed,
    required this.isOptional,
    this.ignoreCacheAnnotation,
    this.defaultValue,
  });

  final String name;
  final String type;
  final bool isNamed;
  final bool isOptional;
  final String? defaultValue;
  final IgnoreCacheAnnotation? ignoreCacheAnnotation;

  factory Param.fromElement(ParameterElement element, Config config) {
    const paramAnnotationChecker = TypeChecker.fromRuntime(IgnoreCache);
    final annotation = paramAnnotationChecker.firstAnnotationOf(element);

    IgnoreCacheAnnotation? annotationData;
    if (annotation != null) {
      if (element.type.getDisplayString(withNullability: true) != 'bool') {
        throw InvalidGenerationSourceError(
          'Ignore cache param need to be not nullable bool',
          element: element,
        );
      }
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
      ignoreCacheAnnotation: annotationData,
      defaultValue: element.defaultValueCode,
      isNamed: element.isNamed,
      isOptional: element.isOptional,
    );
  }

  bool get isPositional => !isNamed;

  bool get isRequired => !isOptional;

  bool get isRequiredPositional => isRequired && isPositional;

  bool get isOptionalPositional => isOptional && isPositional;

  bool get isRequiredNamed => isRequired && isNamed;

  bool get isOptionalNamed => isOptional && isNamed;

  String get typeWithName => '$type $name';
}
