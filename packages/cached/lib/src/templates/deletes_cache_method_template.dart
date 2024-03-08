import 'package:cached/src/models/deletes_cache_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/common_generator.dart';
import 'package:cached/src/utils/persistent_storage_holder_texts.dart';
import 'package:cached/src/utils/utils.dart';

class DeletesCacheMethodTemplate {
  DeletesCacheMethodTemplate(
    this.method,
    this.streamedCacheMethods, {
    this.directPersistedMethods = const [],
    this.isPersisted = false,
    this.isDirectPersisted = false,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final DeletesCacheMethod method;
  final AllParamsTemplate paramsTemplate;
  final List<String> directPersistedMethods;
  final List<StreamedCacheMethod>? streamedCacheMethods;
  final bool isPersisted;
  final bool isDirectPersisted;

  String generateMethod() {
    final asyncModifier = isFuture(method.returnType) ? 'async' : '';
    final awaitIfNeeded = isFuture(method.returnType) ? 'await' : '';

    final params = paramsTemplate.generateParams();
    final paramsUsage = paramsTemplate.generateParamsUsage();

    return '''
    @override
    ${method.returnType} ${method.name}($params) $asyncModifier {
      ${_generatePersistentStorageAwait()}
      
      final result = $awaitIfNeeded super.${method.name}($paramsUsage);

      ${_generateClearMaps()}
      
      ${_mapPersistentStorages()}
      
      return result;
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
    final persistedMethodsToClear = method.methodNames
        .where((method) => !directPersistedMethods.contains(method))
        .toList();

    return [
      ...persistedMethodsToClear.map(_methodToClear),
      ...method.ttlsToClear.map(_methodTtlsToClear),
      ...streamedCacheMethods?.map(clearStreamedCache) ?? <String>[],
    ].join('\n');
  }

  String _methodToClear(String methodToClear) {
    final cacheMapName = getCacheMapName(methodToClear);
    return '$cacheMapName.clear();';
  }

  String _methodTtlsToClear(String ttlToClearMethodName) {
    final ttlMapName = getTtlMapName(ttlToClearMethodName);
    return '$ttlMapName.clear();';
  }

  String _mapPersistentStorages() {
    if (isPersisted || isDirectPersisted) {
      final mappedMethods = method.methodNames.map(_generateClearStorage);
      return '''
         if ($isStorageSetText) {
            ${mappedMethods.join('\n')}
         }
      ''';
    }

    return '';
  }

  String _generateClearStorage(String methodName) {
    final isAsync = method.isAsync;
    final mapName = getCacheMapName(methodName);
    final body =
        isAsync ? "await $deleteText('$mapName')" : "$deleteText('$mapName')";

    return '$body;';
  }
}
