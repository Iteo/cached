import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';

const _defaultSyncWriteValue = false;

class LazyPersistentCachedMethod extends CachedMethod<LazyPersistentCached> {
  LazyPersistentCachedMethod({
    required super.params,
    required super.name,
    required super.syncWrite,
    required super.returnType,
    required super.isGenerator,
    required super.isAsync,
    required super.checkIfShouldCacheMethod,
  }) : super(
          persistentStorage: false,
          lazyPersistentStorage: true,
          limit: null,
          ttl: null,
          initOnCall: false,
        );

  factory LazyPersistentCachedMethod.fromElement(
    MethodElement element,
    Config config,
  ) {
    CachedFunction.assertIsValid(element);

    final localConfig = CachedFunctionLocalConfig.fromElement(element);
    assertPersistentStorageShouldBeAsync(element);

    final unsafeSyncWrite = localConfig.syncWrite ?? config.syncWrite;
    final syncWrite = unsafeSyncWrite ?? _defaultSyncWriteValue;
    final returnType = element.returnType.getDisplayString(
      withNullability: true,
    );
    final params = element.parameters.map(
      (e) => Param.fromElement(e, config),
    );

    final method = LazyPersistentCachedMethod(
      name: element.name,
      syncWrite: syncWrite,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      returnType: returnType,
      params: params,
    );

    assertOneIgnoreCacheParam(method);

    return method;
  }
}
