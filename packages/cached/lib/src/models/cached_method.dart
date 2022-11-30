import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';

const _defaultSyncWriteValue = false;

class CachedMethod extends CachedFunction {
  CachedMethod._({
    required this.params,
    required super.name,
    required super.syncWrite,
    required super.returnType,
    required super.isGenerator,
    required super.isAsync,
    required super.limit,
    required super.ttl,
    required super.checkIfShouldCacheMethod,
  });

  final Iterable<Param> params;

  factory CachedMethod.fromElement(
    MethodElement element,
    Config config,
  ) {
    CachedFunction.assertIsValid(element);

    final localConfig = CachedFunctionLocalConfig.fromAnnotation(
      CachedFunction.getAnnotation(element),
    );

    final method = CachedMethod._(
      name: element.name,
      syncWrite:
          localConfig.syncWrite ?? config.syncWrite ?? _defaultSyncWriteValue,
      limit: localConfig.limit ?? config.limit,
      ttl: localConfig.limit ?? config.ttl,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      returnType: element.returnType.getDisplayString(withNullability: true),
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      params: element.parameters.map((e) => Param.fromElement(e, config)),
    );

    assertOneIgnoreCacheParam(method);

    return method;
  }
}
