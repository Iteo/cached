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

    final localConfig = CachedFunctionLocalConfig.fromElement(element);

    final returnType =
        element.returnType.getDisplayString(withNullability: true);
    final params = element.parameters.map((e) => Param.fromElement(e, config));

    final method = CachedMethod._(
      name: element.name,
      syncWrite:
          localConfig.syncWrite ?? config.syncWrite ?? _defaultSyncWriteValue,
      limit: localConfig.limit ?? config.limit,
      ttl: localConfig.ttl ?? config.ttl,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      returnType: returnType,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      params: params,
    );

    assertOneIgnoreCacheParam(method);

    return method;
  }
}
