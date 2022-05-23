import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:source_gen/source_gen.dart';

final futureRegexp = RegExp(r'^Future<(.+)>$');
final futureBoolRegexp = RegExp(r'^Future<bool>$');
final voidRegexp = RegExp(r'^void$');
final boolRegexp = RegExp(r'^bool$');

String getCacheMapName(String methodName) => '_${methodName}Cached';

bool isReturnsFuture(String returnType) => futureRegexp.hasMatch(returnType);

bool isVoidMethod(String returnType) => voidRegexp.hasMatch(returnType);

bool isReturnsFutureBool(String returnType) => futureBoolRegexp.hasMatch(returnType);

bool isReturnsBool(String returnType) => boolRegexp.hasMatch(returnType);

String syncReturnType(String returnType) {
  if (isReturnsFuture(returnType)) {
    return futureRegexp.firstMatch(returnType)?.group(1) ?? '';
  }

  return returnType;
}

bool checkIsVoidOrReturnsBoolOrFutureBool(String returnType) {
  if (isVoidMethod(returnType)) return false;

  if (isReturnsFutureBool(returnType)) return false;

  if (isReturnsBool(returnType)) return false;

  return true;
}

bool checkIfClearMethodsElementIsCorrect({
  required MethodElement element,
  required bool isClearAllMethod,
}) {
  if (!isClearAllMethod) if (ClearCachedMethod.getAnnotation(element) == null) return false;
  if (isClearAllMethod) if (ClearAllCachedMethod.getAnnotation(element) == null) return false;

  if (element.isAbstract) {
    if (element.isAsynchronous) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` must be not async method',
      );
    }

    if (!element.returnType.isVoid) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` must be a void method',
      );
    }

    if (element.parameters.isNotEmpty) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` method cant have arguments',
      );
    }
  }

  return true;
}
