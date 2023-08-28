import 'package:cached/src/models/cached_getter.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/common_generator.dart';
import 'package:cached/src/utils/persistent_storage_holder_texts.dart';
import 'package:cached/src/utils/utils.dart';

class ClearAllCachedMethodTemplate {
  ClearAllCachedMethodTemplate({
    required this.cachedMethods,
    required this.cachedGetters,
    required Iterable<StreamedCacheMethod> streamedCacheMethods,
    this.method,
    this.isPersisted = false,
  })  : paramsTemplate = AllParamsTemplate(method?.params ?? {}),
        streamedCacheMethodPerName = {
          for (final m in streamedCacheMethods) m.targetMethodName: m,
        };

  final ClearAllCachedMethod? method;
  final Iterable<CachedMethod> cachedMethods;
  final Iterable<CachedGetter> cachedGetters;
  final Map<String, StreamedCacheMethod> streamedCacheMethodPerName;
  final AllParamsTemplate paramsTemplate;
  final bool isPersisted;

  String get asyncModifier => isFuture(method!.returnType) ? 'async' : '';

  String get awaitIfNeeded => isFuture(method!.returnType) ? 'await' : '';

  String generateMethod() {
    if (method == null) {
      return '';
    }

    if (method!.isAbstract) {
      return _generateAbstractMethod();
    }

    final isFutureBoolType = isFutureBool(method!.returnType);
    final isBoolType = isBool(method!.returnType);
    if (isFutureBoolType || isBoolType) {
      return _generateBoolMethod();
    }

    final storageAwait = _generatePersistentStorageAwait();
    final params = paramsTemplate.generateParams();
    final paramsUsage = paramsTemplate.generateParamsUsage();

    return '''
       @override
       ${method!.returnType} ${method!.name}($params) $asyncModifier {
         $storageAwait
         
         $awaitIfNeeded super.${method!.name}($paramsUsage);

         ${_generateCacheClearMethods()}
         ${_generateClearPersistentStorage()}
       }
    ''';
  }

  String _generateCacheClearMethods() {
    return [
      ...cachedMethods.map(_generateClearMapsFromMethod),
      ...cachedGetters.map(_generateClearMapsFromGetter),
    ].join('\n');
  }

  String _generateClearPersistentStorage() {
    if (isPersisted) {
      final isAsync = method?.isAsync ?? false;
      final body = isAsync ? 'await $deleteAllText' : deleteAllText;

      return '''
        if ($isStorageSetText) {
           $body;
        }
      ''';
    }

    return '';
  }

  String _generateBoolMethod() {
    final storageAwait = _generatePersistentStorageAwait();
    final params = paramsTemplate.generateParams();
    final syncType = syncReturnType(method!.returnType);
    final paramsUsage = paramsTemplate.generateParamsUsage();

    return '''
       @override
       ${method!.returnType} ${method!.name}($params) $asyncModifier {
         $storageAwait
         
         final $syncType toReturn;

         final result = super.${method!.name}($paramsUsage);
         toReturn = $awaitIfNeeded result;

         if (toReturn) {
           ${_generateCacheClearMethods()}
         }

         return toReturn;
       }
    ''';
  }

  String _generateAbstractMethod() {
    return '''
       @override
       ${method!.returnType} ${method!.name}() $asyncModifier {
         ${_generateCacheClearMethods()}
       }
    ''';
  }

  String _generatePersistentStorageAwait() {
    return CommonGenerator.generatePersistentStorageAwait(
      isPersisted: isPersisted,
      isAsync: method!.isAsync,
      name: method!.name,
    );
  }

  String _generateClearMapsFromMethod(CachedMethod clearedMethod) {
    final baseName = clearedMethod.name;
    return _generateClearMaps(
      baseName,
      streamedCacheMethodPerName[baseName],
    );
  }

  String _generateClearMapsFromGetter(CachedGetter clearedMethod) {
    final baseName = clearedMethod.name;
    return _generateClearMaps(
      baseName,
      streamedCacheMethodPerName[baseName],
    );
  }

  String _generateClearMaps(
    String baseName,
    StreamedCacheMethod? streamedCacheMethod,
  ) {
    final cacheMapName = getCacheMapName(baseName);
    final containsTtl = method?.ttlsToClear.contains(baseName) ?? false;
    final ttlMapName = getTtlMapName(baseName);
    final clearTtl = containsTtl ? '$ttlMapName.clear();' : '';
    final clearedStreamCache = clearStreamedCache(streamedCacheMethod);

    return '''
       $cacheMapName.clear();
       $clearTtl
       $clearedStreamCache
    ''';
  }
}
