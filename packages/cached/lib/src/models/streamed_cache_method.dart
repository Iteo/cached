import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

class StreamedCacheMethod {
  const StreamedCacheMethod({
    required this.name,
    required this.targetMethodName,
    required this.coreReturnType,
    required this.params,
    required this.emitLastValue,
    required this.coreReturnTypeNullable,
  });

  factory StreamedCacheMethod.fromElement(
    MethodElement element,
    List<ExecutableElement> classMethods,
    Config config,
  ) {
    final annotation = getAnnotation(element);

    var methodName = '';
    var emitLastValue = false;

    if (annotation != null) {
      final reader = ConstantReader(annotation);
      emitLastValue = reader.read('emitLastValue').boolValue;
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
    const streamTypeChecker = TypeChecker.typeNamed(Stream);
    final coreCacheStreamMethodType = element.returnType
        .typeArgumentsOf(streamTypeChecker)
        ?.single;
    final coreCacheSteamMethodTypeStr = coreCacheStreamMethodType
        ?.getDisplayString();

    const futureTypeChecker = TypeChecker.typeNamed(Future);
    final targetMethodSyncReturnType = targetMethod.returnType.isDartAsyncFuture
        ? targetMethod.returnType.typeArgumentsOf(futureTypeChecker)?.single
        : targetMethod.returnType;

    final targetMethodSyncTypeStr = targetMethodSyncReturnType
        ?.getDisplayString();

    if (coreCacheSteamMethodTypeStr != targetMethodSyncTypeStr) {
      throw InvalidGenerationSourceError(
        '[ERROR] Streamed cache method return type needs to be a Stream<$targetMethodSyncTypeStr>',
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
        '[ERROR] Method "${targetMethod.name}" should have same parameters as "${element.name}", excluding ones marked with @ignore and @ignoreCache',
        element: element,
      );
    }

    return StreamedCacheMethod(
      name: element.displayName,
      coreReturnType: coreCacheSteamMethodTypeStr ?? 'dynamic',
      emitLastValue: emitLastValue,
      params: targetMethodParameters.map((p) => Param.fromElement(p, config)),
      targetMethodName: methodName,
      coreReturnTypeNullable:
          coreCacheStreamMethodType?.nullabilitySuffix ==
          NullabilitySuffix.question,
    );
  }

  final String name;
  final String targetMethodName;
  final Iterable<Param> params;
  final String coreReturnType;
  final bool emitLastValue;
  final bool coreReturnTypeNullable;

  static DartObject? getAnnotation(ExecutableElement element) {
    const methodAnnotationChecker = TypeChecker.typeNamed(StreamedCache);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
