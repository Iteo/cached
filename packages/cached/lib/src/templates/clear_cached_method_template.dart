import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class ClearCachedMethodTemplate {
  ClearCachedMethodTemplate(this.method, {this.streamedCacheMethod})
      : paramsTemplate = AllParamsTemplate(method.params);

  final ClearCachedMethod method;
  final AllParamsTemplate paramsTemplate;
  final StreamedCacheMethod? streamedCacheMethod;

  String get asyncModifier => isFuture(method.returnType) ? 'async' : '';
  String get awaitIfNeeded => isFuture(method.returnType) ? 'await' : '';

  String generateMethod() {
    if (method.isAbstract) return _generateAbstractMethod();

    if (isFutureBool(method.returnType) || isBool(method.returnType)) {
      return _generateBoolMethod();
    }

    return '''
    @override
    ${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) $asyncModifier {
      $awaitIfNeeded super.${method.name}(${paramsTemplate.generateParamsUsage()});

      ${_generateClearMaps()}
    }
    ''';
  }

  String _generateBoolMethod() {
    return '''
    @override
    ${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) $asyncModifier {
      final ${syncReturnType(method.returnType)} toReturn;

      final result = super.${method.name}(${paramsTemplate.generateParamsUsage()});
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

  String _generateClearMaps() {
    return '''
${getCacheMapName(method.methodName)}.clear();
${method.shouldClearTtl ? "${getTtlMapName(method.methodName)}.clear();" : ""}
${clearStreamedCache(streamedCacheMethod)}
''';
  }
}
