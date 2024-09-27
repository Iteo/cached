import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:collection/collection.dart';

import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

class CachePeekMethod {
  const CachePeekMethod({
    required this.name,
    required this.targetMethodName,
    required this.returnType,
    required this.params,
    required this.targetHasTtl,
  });

  factory CachePeekMethod.fromElement(
    MethodElement element,
    List<ExecutableElement> classMethods,
    Config config,
  ) {
    final annotation = getAnnotation(element);

    var methodName = '';

    if (annotation != null) {
      final reader = ConstantReader(annotation);
      methodName = reader.read('methodName').stringValue;
    }

    final targetMethod = classMethods
        .where((m) => m.name == methodName)
        .firstOrNull;

    if (targetMethod == null) {
      throw InvalidGenerationSourceError(
        '[ERROR] Method "$methodName" do not exists',
        element: element,
      );
    }

    final peekCacheMethodType = element.returnType;
    final peekCacheMethodTypeStr = peekCacheMethodType.getDisplayString(
      withNullability: false,
    );

    const futureTypeChecker = TypeChecker.typeNamed(Future);
    final targetMethodReturnType = targetMethod.returnType.isDartAsyncFuture
        ? targetMethod.returnType.typeArgumentsOf(futureTypeChecker)?.single
        : targetMethod.returnType;

    final targetMethodTypeStr = targetMethodReturnType?.getDisplayString(
      withNullability: false,
    );

    if (peekCacheMethodTypeStr != targetMethodTypeStr) {
      throw InvalidGenerationSourceError(
        '[ERROR] Peek cache method return type needs to be a $targetMethodTypeStr?',
        element: element,
      );
    }

    const cachedAnnotationTypeChecker = TypeChecker.typeNamed(Cached);

    if (!cachedAnnotationTypeChecker.hasAnnotationOf(targetMethod)) {
      throw InvalidGenerationSourceError(
        '[ERROR] Method "$methodName" do not have @cached annotation',
        element: element,
      );
    }

    final cachedAnnotation = cachedAnnotationTypeChecker.firstAnnotationOf(
      targetMethod,
    );
    final hasDirectPersistenStorage =
        cachedAnnotation?.getField('directPersistentStorage')?.toBoolValue() ??
        false;
    if (hasDirectPersistenStorage) {
      throw InvalidGenerationSourceError(
        "[ERROR] Method '$methodName' has 'directPersistentStorage' set to true."
        "@CachePeek is unavailable for methods with 'directPersistentStorage'.",
        element: element,
      );
    }

    const ignoreTypeChecker = TypeChecker.any([
      TypeChecker.typeNamed(Ignore),
      TypeChecker.typeNamed(IgnoreCache),
    ]);

    final targetMethodParameters = targetMethod.formalParameters
        .where((p) => !ignoreTypeChecker.hasAnnotationOf(p))
        .toList();

    if (!ListEquality<FormalParameterElement>(
      EqualityBy((p) => Param.fromElement(p, config)),
    ).equals(targetMethodParameters, element.formalParameters)) {
      throw InvalidGenerationSourceError(
        '[ERROR] Method "${targetMethod.name}" should have same parameters as '
        '"${element.name}", excluding ones marked with @ignore and @ignoreCache',
        element: element,
      );
    }

    bool targetMethodHasTtl = false;

    try {
      final targetLocalConfig =
          CachedFunctionLocalConfig.fromElement(targetMethod);
      targetMethodHasTtl = targetLocalConfig.ttl != null;
    } catch (e) {
      print(e);
      // ignore
    }

    return CachePeekMethod(
      name: element.displayName,
      returnType: peekCacheMethodTypeStr,
      params: targetMethodParameters.map((p) => Param.fromElement(p, config)),
      targetMethodName: methodName,
      targetHasTtl: targetMethodHasTtl,
    );
  }

  final String name;
  final String targetMethodName;
  final Iterable<Param> params;
  final String returnType;
  final bool targetHasTtl;

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.typeNamed(CachePeek);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
