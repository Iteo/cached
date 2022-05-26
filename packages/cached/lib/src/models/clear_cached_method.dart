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
    required this.shouldClearTtl,
  });

  final String name;
  final String methodName;
  final String returnType;
  final bool isGenerator;
  final bool isAbstract;
  final bool isAsync;
  final Iterable<Param> params;
  final bool shouldClearTtl;

  factory ClearCachedMethod.fromElement(
    MethodElement element,
    Config config,
    Set<String> ttlsToClear,
  ) {
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
          '''
[ERROR] Name of method for which cache should be cleared is not provider.
Provide it trougth annotation parameter (`@ClearCached('methodName')`)
or trougth clear function name e.g. `void ${_clearPrefix}MethodName();`
''',
          element: element,
        );
      }

      methodName =
          element.name.replaceAll(_clearPrefix, '').startsWithLowerCase();
    }

    return ClearCachedMethod(
      name: element.name,
      methodName: methodName,
      returnType: element.returnType.getDisplayString(withNullability: true),
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      isAbstract: element.isAbstract,
      params: element.parameters.map((e) => Param.fromElement(e, config)),
      shouldClearTtl: ttlsToClear.contains(methodName),
    );
  }

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(ClearCached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
