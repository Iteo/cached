import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_function_local_config.dart';
import 'package:cached/src/models/getters/cached_getter.dart';
import 'package:cached_annotation/cached_annotation.dart';

const _defaultSyncWriteValue = false;

class LazyPersistentCachedGetter extends CachedGetter<LazyPersistentCached> {
  LazyPersistentCachedGetter({
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
        );

  factory LazyPersistentCachedGetter.fromElement(
    PropertyAccessorElement element,
    Config config,
  ) {
    CachedFunction.assertIsValid(element);

    final localConfig = CachedFunctionLocalConfig.fromElement(element);
    final unsafeSyncWrite = localConfig.syncWrite ?? config.syncWrite;
    final syncWrite = unsafeSyncWrite ?? _defaultSyncWriteValue;
    final returnType = element.returnType.getDisplayString(
      withNullability: true,
    );

    return LazyPersistentCachedGetter(
      name: element.name,
      syncWrite: syncWrite,
      checkIfShouldCacheMethod: localConfig.checkIfShouldCacheMethod,
      returnType: returnType,
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
    );
  }
}
