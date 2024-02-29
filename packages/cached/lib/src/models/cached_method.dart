import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';

const _defaultSyncWriteValue = false;

class CachedMethod<T extends Cached> extends CachedFunction {
  CachedMethod({
    required this.params,
    required super.name,
    required super.syncWrite,
    required super.returnType,
    required super.isGenerator,
    required super.isAsync,
    required super.limit,
    required super.ttl,
    required super.checkIfShouldCacheMethod,
    required super.persistentStorage,
    required super.lazyPersistentStorage,
    required super.initOnCall,
  });

  factory CachedMethod.fromElement(
    MethodElement element,
    Config config,
  ) {
    CachedFunction.assertIsValid(element);

    final localConfig = CachedFunctionLocalConfig.fromElement(element);
    if (localConfig.persistentStorage || localConfig.lazyPersistentStorage) {
      assertPersistentStorageShouldBeAsync(element);
    }

    final unsafeSyncWrite = localConfig.syncWrite ?? config.syncWrite;
    final syncWrite = unsafeSyncWrite ?? _defaultSyncWriteValue;
    final limit = localConfig.limit ?? config.limit;
    final ttl = localConfig.ttl ?? config.ttl;
    final persistentStorage = localConfig.persistentStorage;
    final lazyPersistentStorage = localConfig.lazyPersistentStorage;
    final returnType = element.returnType.getDisplayString(
      withNullability: true,
    );
    final params = element.parameters.map(
      (e) => Param.fromElement(e, config),
    );

    final method = CachedMethod<T>(
      name: element.name,
      syncWrite: syncWrite,
      limit: limit,
      ttl: ttl,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      persistentStorage: persistentStorage,
      lazyPersistentStorage: lazyPersistentStorage,
      returnType: returnType,
      params: params,
      initOnCall: localConfig.initOnCall ?? false,
    );

    assertOneIgnoreCacheParam(method);

    return method;
  }

  final Iterable<Param> params;
}
