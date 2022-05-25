import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class ClearAllCachedMethodTemplate {
  ClearAllCachedMethodTemplate({this.method, required this.cachedMethods})
      : paramsTemplate = AllParamsTemplate(method?.params ?? {});

  final ClearAllCachedMethod? method;
  final Iterable<CachedMethod> cachedMethods;
  final AllParamsTemplate paramsTemplate;

  String _generateCacheClearMethods() => cachedMethods
      .map((e) => e.name)
      .map(_generateClearMaps)
      .join("\n");

  String generateMethod() {
    if (method == null) return '';

    if (method!.isAbstract) return _generateAbstractMethod();
    if (isVoid(method!.returnType)) return _generateVoidMethod();

    final asyncModifier = isFuture(method!.returnType) ? 'async' : '';
    final awaitIfNeeded = isFuture(method!.returnType) ? 'await' : '';

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

  String _generateVoidMethod() {
    return '''
    @override
      ${method!.returnType} ${method!.name}(${paramsTemplate.generateParams()}) {
      super.${method!.name}(${paramsTemplate.generateParamsUsage()});

      ${_generateCacheClearMethods()}
    }
    ''';
  }

  String _generateAbstractMethod() {
    return '''
    @override
    void ${method!.name}() {
      ${_generateCacheClearMethods()}
    }
    ''';
  }
  
  String _generateClearMaps(String baseName) {
    return '''
${getCacheMapName(baseName)}.clear();
${method?.ttlsToClear.contains(baseName) ?? false ? "${getTtlMapName(baseName)}.clear();" : ""}
''';
  }
}
