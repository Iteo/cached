import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached_annotation/cached_annotation.dart';

const _defaultSyncWriteValue = false;

class CachedGetter extends CachedFunction {
  CachedGetter({
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

  factory CachedGetter.fromElement(
    PropertyAccessorElement element,
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

    return CachedGetter(
      name: element.name,
      syncWrite: syncWrite,
      limit: limit,
      ttl: ttl,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      persistentStorage: persistentStorage,
      lazyPersistentStorage: isLazy,
      returnType: returnType,
      initOnCall: initOnCall,
    );
  }
}
