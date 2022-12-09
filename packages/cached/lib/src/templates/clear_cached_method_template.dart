import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/common_generator.dart';
import 'package:cached/src/utils/persistent_storage_holder_texts.dart';
import 'package:cached/src/utils/utils.dart';

class ClearCachedMethodTemplate {
  ClearCachedMethodTemplate(
    this.method, {
    this.streamedCacheMethod,
    this.isPersisted = false,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final ClearCachedMethod method;
  final AllParamsTemplate paramsTemplate;
  final StreamedCacheMethod? streamedCacheMethod;
  final bool isPersisted;

  String get asyncModifier => isFuture(method.returnType) ? 'async' : '';

  String get awaitIfNeeded => isFuture(method.returnType) ? 'await' : '';

  String generateMethod() {
    if (method.isAbstract) {
      return _generateAbstractMethod();
    }

    final isFutureBoolType = isFutureBool(method.returnType);
    final isBoolType = isBool(method.returnType);
    if (isFutureBoolType || isBoolType) {
      return _generateBoolMethod();
    }

    final storageAwait = _generatePersistentStorageAwait();
    final params = paramsTemplate.generateParams();
    final paramsUsage = paramsTemplate.generateParamsUsage();

    return '''
       @override
       ${method.returnType} ${method.name}($params) $asyncModifier {
         $storageAwait
         
         $awaitIfNeeded super.${method.name}($paramsUsage);
   
         ${_generateClearMaps()}
      
         ${_generateClearPersistentStorage()}
       }
    ''';
  }

  String _generateBoolMethod() {
    final storageAwait = _generatePersistentStorageAwait();
    final params = paramsTemplate.generateParams();
    final paramsUsage = paramsTemplate.generateParamsUsage();
    final syncType = syncReturnType(method.returnType);

    return '''
       @override
       ${method.returnType} ${method.name}($params) $asyncModifier {
         $storageAwait
         
         final $syncType toReturn;

         final result = super.${method.name}($paramsUsage);
         toReturn = $awaitIfNeeded result;

         if(toReturn) {
           ${_generateClearMaps()}
         }

         return toReturn;
       }
    ''';
  }

  String _generateAbstractMethod() {
    return '''
       @override
       ${method.returnType} ${method.name}() $asyncModifier {
         ${_generateClearMaps()}
       }
    ''';
  }

  String _generatePersistentStorageAwait() {
    return CommonGenerator.generatePersistentStorageAwait(
      isPersisted: isPersisted,
      isAsync: method.isAsync,
      name: method.name,
    );
  }

  String _generateClearMaps() {
    final cacheMapName = getCacheMapName(method.methodName);
    final ttlMapName = getTtlMapName(method.methodName);
    final shouldClearTtl = method.shouldClearTtl ? '$ttlMapName.clear();' : '';
    final clearedStreamCache = clearStreamedCache(streamedCacheMethod);

    return '''
       $cacheMapName.clear();
       $shouldClearTtl
       $clearedStreamCache
    ''';
  }

  String _generateClearPersistentStorage() {
    if (isPersisted) {
      final isAsync = method.isAsync;
      final mapName = getCacheMapName(method.methodName);
      final body = isAsync
          ? "await $deleteText('$mapName')"
          : "$deleteText('$mapName')";

      return '''
        if ($isStorageSetText) {
           $body;
        }
      ''';
    }

    return '';
  }
}
