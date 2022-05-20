import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:source_gen/source_gen.dart';

class ClearCachedMethodTemplate {
  ClearCachedMethodTemplate(this.method) : paramsTemplate = AllParamsTemplate(method.params);

  final ClearCachedMethod method;
  final AllParamsTemplate paramsTemplate;

  bool _checkIsVoidOrReturnsBoolOrFutureBool() {
    if (isVoidMethod(method.returnType)) return false;

    if (isReturnsFutureBool(method.returnType)) return false;

    if (isReturnsBool(method.returnType)) return false;

    return true;
  }

  String generateMethod() {
    if (_checkIsVoidOrReturnsBoolOrFutureBool()) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${method.name}` must be a void method or return bool, Future<bool>',
      );
    }

    if (method.isAbstract) return _generateAbstractMethod();
    if (isVoidMethod(method.returnType)) return _generateVoidMethod();

    final asyncModifier = isReturnsFuture(method.returnType) ? 'async' : '';
    final awaitIfNeeded = isReturnsFuture(method.returnType) ? 'await' : '';

    return '''
    @override
    ${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) $asyncModifier {
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

  String _generateVoidMethod() {
    return '''
    @override
      ${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) {
      super.${method.name}(${paramsTemplate.generateParamsUsage()});

      ${getCacheMapName(method.methodName)}.clear();
    }
    ''';
  }

  String _generateAbstractMethod() {
    return '''
    @override
    void ${method.name}() => ${getCacheMapName(method.methodName)}.clear();
    ''';
  }
}
