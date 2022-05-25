import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class ClearCachedMethodTemplate {
  ClearCachedMethodTemplate(this.method)
      : paramsTemplate = AllParamsTemplate(method.params);

  final ClearCachedMethod method;
  final AllParamsTemplate paramsTemplate;

  String generateMethod() {
    if (method.isAbstract) return _generateAbstractMethod();
    if (isVoid(method.returnType)) return _generateVoidMethod();

    final asyncModifier = isFuture(method.returnType) ? 'async' : '';
    final awaitIfNeeded = isFuture(method.returnType) ? 'await' : '';

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

  String _generateVoidMethod() {
    return '''
    @override
      ${_generateClearMaps()}
      super.${method.name}(${paramsTemplate.generateParamsUsage()});

      ${getCacheMapName(method.methodName)}.clear();
    }
    ''';
  }

  String _generateAbstractMethod() {
    return '''
    @override
    void ${method.name}() {
      ${_generateClearMaps()}
    } 
    ''';
  }

  String _generateClearMaps() {
    return '''
${getCacheMapName(method.methodName)}.clear();
${method.shouldClearTtl ? "${getTtlMapName(method.methodName)}.clear();" : ""}
''';
  }
}
