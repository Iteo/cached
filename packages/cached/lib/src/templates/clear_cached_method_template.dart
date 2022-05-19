import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class ClearCachedMethodTemplate {
  ClearCachedMethodTemplate(this.method) : paramsTemplate = AllParamsTemplate(method.params);

  final ClearCachedMethod method;
  final AllParamsTemplate paramsTemplate;

  String generateMethod() {
    if (method.isAbstract) return generateAbstractMethod();
    if (isVoidMethod(method.returnType)) return generateVoidMethod();

    final syncModifier = method.isGenerator && !isReturnsFuture(method.returnType) ? 'sync' : '';
    final asyncModifier = isReturnsFuture(method.returnType) ? 'async' : '';
    final generatorModifier = method.isGenerator ? '*' : '';
    final awaitIfNeeded = isReturnsFuture(method.returnType) ? 'await' : '';

    return '''
    @override
    ${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) $syncModifier$asyncModifier$generatorModifier {
      final ${syncReturnType(method.returnType)} toReturn;

      final result = super.${method.name}(${paramsTemplate.generateParamsUsage()});
      toReturn = $awaitIfNeeded result;

      if(toReturn) {
        ${getCacheMapName(method.methodName)}.clear();
      }

      return toReturn;
    }
    ''';
  }

  String generateVoidMethod() {
    return '''
    @override
      ${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) {
      super.${method.name}(${paramsTemplate.generateParamsUsage()});

      ${getCacheMapName(method.methodName)}.clear();
    }
    ''';
  }

  String generateAbstractMethod() {
    return '''
    @override
    void ${method.name}() => ${getCacheMapName(method.methodName)}.clear();
    ''';
  }
}
