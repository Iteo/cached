import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/extensions.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached_annotation/cached_annotation.dart';

import 'package:source_gen/source_gen.dart';

const String _clearPrefix = 'clear';

class ClearCachedMethod {
  const ClearCachedMethod({
    required this.name,
    required this.methodName,
    required this.returnType,
    required this.isAsync,
    required this.params,
    required this.isGenerator,
    required this.isAbstract,
  });

  final String name;
  final String methodName;
  final String returnType;
  final bool isGenerator;
  final bool isAbstract;
  final bool isAsync;
  final Iterable<Param> params;

  factory ClearCachedMethod.fromElement(MethodElement element, Config config) {
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
          'Set in method ${element.name} argument or add `$_clearPrefix` to cached name function i.e. ${_clearPrefix}Strings',
        );
      }

      methodName = element.name.replaceAll(_clearPrefix, '').startsWithLowerCase();
    }

    return ClearCachedMethod(
      name: element.name,
      methodName: methodName,
      returnType: element.returnType.getDisplayString(withNullability: true),
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      isAbstract: element.isAbstract,
      params: element.parameters.map((e) => Param.fromElement(e, config)),
    );
  }

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(ClearCached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
