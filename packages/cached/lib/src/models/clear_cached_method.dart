import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/extensions.dart';
import 'package:cached_annotation/cached_annotation.dart';

import 'package:source_gen/source_gen.dart';

const String _clearPrefix = 'clear';

class ClearCachedMethod {
  const ClearCachedMethod(this.name, this.methodName);

  final String name;
  final String methodName;

  factory ClearCachedMethod.fromElement(MethodElement element) {
    final annotation = getAnnotation(element);

    String? methodName;

    if (annotation != null) {
      final reader = ConstantReader(annotation);
      final methodNameField = reader.read('methodName');

      if (methodNameField.isString) {
        methodName = methodNameField.stringValue;
      }
    }

    if (methodName == null || methodName.isEmpty) {
      if (!element.name.contains(_clearPrefix)) {
        throw InvalidGenerationSourceError(
          'Set in method ${element.name} argument or add `$_clearPrefix` to cached name function i.e. $_clearPrefix}Strings',
        );
      }

      methodName =
          element.name.replaceAll(_clearPrefix, '').startsWithLowerCase();
    }

    return ClearCachedMethod(element.name, methodName);
  }

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(ClearCached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
