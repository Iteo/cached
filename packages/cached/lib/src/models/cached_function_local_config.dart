import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/check_if_should_cache_method.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:source_gen/source_gen.dart';

class CachedFunctionLocalConfig {
  CachedFunctionLocalConfig({
    required this.syncWrite,
    required this.limit,
    required this.ttl,
    required this.checkIfShouldCacheMethod,
  });

  bool? syncWrite;
  int? limit;
  int? ttl;
  CheckIfShouldCacheMethod? checkIfShouldCacheMethod;

  factory CachedFunctionLocalConfig.fromElement(
    ExecutableElement element,
  ) {
    bool? syncWrite;
    int? limit;
    int? ttl;
    CheckIfShouldCacheMethod? checkIfShouldCacheMethod;

    final annotation = CachedFunction.getAnnotation(element);
    if (annotation != null) {
      final reader = ConstantReader(annotation);

      syncWrite = reader.peek('syncWrite')?.boolValue;
      limit = reader.peek('limit')?.intValue;
      ttl = reader.peek('ttl')?.intValue;

      final whereFunc = reader.peek('where')?.objectValue.toFunctionValue();

      if (whereFunc != null) {
        final whereFuncReturnType =
            whereFunc.returnType.getDisplayString(withNullability: false);

        if (!(isFutureBool(whereFuncReturnType) ||
            isBool(whereFuncReturnType))) {
          throw InvalidGenerationSourceError(
            '[ERROR] `${whereFunc.name}` must be a bool or Future<bool> method',
            element: whereFunc,
          );
        }

        final annotatedMethodReturnType =
            element.returnType.getDisplayString(withNullability: false);
        final syncAnnotatedMethodType =
            syncReturnType(annotatedMethodReturnType);

        if ((isFuture(annotatedMethodReturnType) &&
                !isFuture(whereFuncReturnType)) ||
            (isFuture(whereFuncReturnType) &&
                !isFuture(annotatedMethodReturnType))) {
          throw InvalidGenerationSourceError(
            '[ERROR] Asynchronous and synchronous mismatch. Check return types of: ${element.name} and ${whereFunc.name}.',
            element: whereFunc,
          );
        }

        final params = whereFunc.parameters;
        if (params.length != 1) {
          throw InvalidGenerationSourceError(
            '[ERROR] `${whereFunc.name}` should have exactly one parameter',
            element: whereFunc,
          );
        }
        final param = whereFunc.parameters[0];
        final paramType = param.type;
        final syncParamType =
            syncReturnType(paramType.getDisplayString(withNullability: false));

        if (syncParamType != syncAnnotatedMethodType) {
          throw InvalidGenerationSourceError(
            '[ERROR] Condition parameter: ${param.name} (of type $paramType) should have the same type as annotated method: ${element.name} (of type ${element.returnType}).',
            element: whereFunc,
          );
        }

        checkIfShouldCacheMethod = CheckIfShouldCacheMethod(
          name: whereFunc.name,
          returnType: whereFuncReturnType,
          isAsync: whereFunc.isAsynchronous || isFuture(whereFuncReturnType),
        );
      }
    }

    return CachedFunctionLocalConfig(
      ttl: ttl,
      limit: limit,
      syncWrite: syncWrite,
      checkIfShouldCacheMethod: checkIfShouldCacheMethod,
    );
  }
}
