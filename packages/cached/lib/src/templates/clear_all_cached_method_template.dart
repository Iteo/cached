import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:source_gen/source_gen.dart';

class ClearAllCachedMethodTemplate {
  ClearAllCachedMethodTemplate({this.method, required this.cachedMethods})
      : paramsTemplate = AllParamsTemplate(method?.params ?? {});

  final ClearAllCachedMethod? method;
  final Iterable<CachedMethod> cachedMethods;
  final AllParamsTemplate paramsTemplate;

  String _generateCacheClearMethods() => cachedMethods.map((e) => "${getCacheMapName(e.name)}.clear();").join("\n");

  String generateMethod() {
    if (method == null) return '';

    if (checkIsVoidOrReturnsBoolOrFutureBool(method!.returnType)) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${method!.name}` must be a void method or return bool, Future<bool>',
      );
    }

    if (method!.isAbstract) return _generateAbstractMethod();
    if (isVoidMethod(method!.returnType)) return _generateVoidMethod();

    final asyncModifier = isReturnsFuture(method!.returnType) ? 'async' : '';
    final awaitIfNeeded = isReturnsFuture(method!.returnType) ? 'await' : '';

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
}
