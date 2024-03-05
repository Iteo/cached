import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';

const _defaultSyncWriteValue = false;

class CachedMethod extends CachedFunction {
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

    var isLazy = false;
    var isPersistent = false;

    if (CachedFunction.hasCachedAnnotation<LazyPersistentCached>(element)) {
      isLazy = true;
    } else if (CachedFunction.hasCachedAnnotation<PersistentCached>(element)) {
      isPersistent = true;
    }

    final localConfig = CachedFunctionLocalConfig.fromElement(element);
    final unsafeSyncWrite = localConfig.syncWrite ?? config.syncWrite;
    final syncWrite = unsafeSyncWrite ?? _defaultSyncWriteValue;
    final limit = isLazy ? null : localConfig.limit ?? config.limit;
    final ttl = isLazy ? null : localConfig.ttl ?? config.ttl;
    final persistentStorage = isPersistent || localConfig.persistentStorage;
    final initOnCall = !isLazy && isPersistent && localConfig.initOnCall;
    final returnType = element.returnType.getDisplayString(
      withNullability: true,
    );
    final params = element.parameters.map(
      (e) => Param.fromElement(e, config),
    );

    final method = CachedMethod(
      name: element.name,
      syncWrite: syncWrite,
      limit: limit,
      ttl: ttl,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      persistentStorage: persistentStorage,
      lazyPersistentStorage: isLazy,
      params: params,
      initOnCall: initOnCall,
      returnType: returnType,
    );

    assertOneIgnoreCacheParam(method);

    return method;
  }

  final Iterable<Param> params;
}
