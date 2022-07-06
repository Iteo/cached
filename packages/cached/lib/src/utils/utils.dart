import 'package:cached/src/models/param.dart';
import 'package:cached/src/models/streamed_cache_method.dart';

final futureRegexp = RegExp(r'^Future<(.+)>$');
final futureBoolRegexp = RegExp(r'^Future<bool>$');
final futureVoidRegexp = RegExp(r'^Future<void>$');
final voidRegexp = RegExp(r'^void$');
final boolRegexp = RegExp(r'^bool$');

String getCacheStreamControllerName(String targetMethodName) =>
    '_${targetMethodName}CacheStreamController';

String getParamKey(Iterable<Param> params) => params
    .where(
      (element) =>
          element.ignoreCacheAnnotation == null && !element.ignoreCacheKey,
    )
    .map(
      (e) => _generateParamKeyPartCall(
        name: e.name,
        cacheKeyAnnotation: e.cacheKeyAnnotation,
      ),
    )
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

String clearStreamedCache(StreamedCacheMethod? method) {
  if (method != null && method.coreReturnTypeNullable) {
    final controllerName =
        getCacheStreamControllerName(method.targetMethodName);

    return '''
        $controllerName.sink.add(MapEntry(StreamEventIdentifier(
          instance: this,
        ), 
        null,
        ));
      ''';
  }
  return '';
}

String _generateParamKeyPartCall({
  required String name,
  required CacheKeyAnnotation? cacheKeyAnnotation,
}) =>
    cacheKeyAnnotation != null
        ? "\${${cacheKeyAnnotation.cacheFunctionCall}($name)}"
        : '\${$name.hashCode}';

extension Inspect<T> on Iterable<T> {
  Iterable<T> inspect(void Function(T) fn) sync* {
    for (final value in this) {
      fn(value);
      yield value;
    }
  }
}
