final futureRegexp = RegExp(r'^Future<(.+)>$');
final futureBoolRegexp = RegExp(r'^Future<bool>$');
final voidRegexp = RegExp(r'^void$');

String getCacheMapName(String methodName) => '_${methodName}Cached';

bool isReturnsFuture(String returnType) => futureRegexp.hasMatch(returnType);

bool isVoidMethod(String returnType) => voidRegexp.hasMatch(returnType);

bool isReturnsFutureBool(String returnType) => futureBoolRegexp.hasMatch(returnType);

String syncReturnType(String returnType) {
  if (isReturnsFuture(returnType)) {
    return futureRegexp.firstMatch(returnType)?.group(1) ?? '';
  }

  return returnType;
}
