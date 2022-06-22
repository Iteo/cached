import 'package:cached/src/models/param.dart';

final futureRegexp = RegExp(r'^Future<(.+)>$');
final futureBoolRegexp = RegExp(r'^Future<bool>$');
final futureVoidRegexp = RegExp(r'^Future<void>$');
final voidRegexp = RegExp(r'^void$');
final boolRegexp = RegExp(r'^bool$');

String getCacheStreamMapName(String targetMethodName) =>
    '_${targetMethodName}CacheStream';

String getParamKey(Iterable<Param> params) => params
    .where(
      (element) =>
          element.ignoreCacheAnnotation == null && !element.ignoreCacheKey,
    )
    .map((e) => '\${${e.name}.hashCode}')
    .join();

String getCacheMapName(String methodName) => '_${methodName}Cached';

String getTtlMapName(String methodName) => '_${methodName}Ttl';

bool isFuture(String returnType) => futureRegexp.hasMatch(returnType);

bool isVoid(String returnType) => voidRegexp.hasMatch(returnType);

bool isAsyncVoid(String returnType) => futureVoidRegexp.hasMatch(returnType);

bool isFutureBool(String returnType) => futureBoolRegexp.hasMatch(returnType);

bool isBool(String returnType) => boolRegexp.hasMatch(returnType);

String syncReturnType(String returnType) {
  if (isFuture(returnType)) {
    return futureRegexp.firstMatch(returnType)?.group(1) ?? '';
  }

  return returnType;
}

extension Inspect<T> on Iterable<T> {
  Iterable<T> inspect(void Function(T) fn) sync* {
    for (final value in this) {
      fn(value);
      yield value;
    }
  }
}
