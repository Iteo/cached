import 'package:cached/src/models/cached_getter.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class ClearAllCachedMethodTemplate {
  ClearAllCachedMethodTemplate({
    this.method,
    required this.cachedMethods,
    required this.cachedGetters,
    required Iterable<StreamedCacheMethod> streamedCacheMethods,
  })  : paramsTemplate = AllParamsTemplate(method?.params ?? {}),
        streamedCacheMethodPerName = {
          for (final m in streamedCacheMethods) m.targetMethodName: m
        };

  final ClearAllCachedMethod? method;
  final Iterable<CachedMethod> cachedMethods;
  final Iterable<CachedGetter> cachedGetters;
  final Map<String, StreamedCacheMethod> streamedCacheMethodPerName;
  final AllParamsTemplate paramsTemplate;

  String get asyncModifier => isFuture(method!.returnType) ? 'async' : '';
  String get awaitIfNeeded => isFuture(method!.returnType) ? 'await' : '';

  String _generateCacheClearMethods() => [
        ...cachedMethods.map(_generateClearMapsFromMethod),
        ...cachedGetters.map(_generateClearMapsFromGetter),
      ].join("\n");

  String generateMethod() {
    if (method == null) return '';

    if (method!.isAbstract) return _generateAbstractMethod();

    if (isFutureBool(method!.returnType) || isBool(method!.returnType)) {
      return _generateBoolMethod();
    }

    return '''
    @override
    ${method!.returnType} ${method!.name}(${paramsTemplate.generateParams()}) $asyncModifier {
      $awaitIfNeeded super.${method!.name}(${paramsTemplate.generateParamsUsage()});

      ${_generateCacheClearMethods()}
    }
    ''';
  }

  String _generateBoolMethod() {
    return '''
    @override
    ${method!.returnType} ${method!.name}(${paramsTemplate.generateParams()}) $asyncModifier {
      final ${syncReturnType(method!.returnType)} toReturn;

      final result = super.${method!.name}(${paramsTemplate.generateParamsUsage()});
      toReturn = $awaitIfNeeded result;

      if(toReturn) {
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
    return '''
${getCacheMapName(baseName)}.clear();
${method?.ttlsToClear.contains(baseName) ?? false ? "${getTtlMapName(baseName)}.clear();" : ""}
${clearStreamedCache(streamedCacheMethod)}
''';
  }
}
