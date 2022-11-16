import 'package:cached/src/models/deletes_cache_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class DeletesCacheMethodTemplate {
  DeletesCacheMethodTemplate(
    this.method,
    this.streamedCacheMethods,
  ) : paramsTemplate = AllParamsTemplate(method.params);

  final DeletesCacheMethod method;
  final AllParamsTemplate paramsTemplate;
  final List<StreamedCacheMethod>? streamedCacheMethods;

  String generateMethod() {
    final asyncModifier = isFuture(method.returnType) ? 'async' : '';
    final awaitIfNeeded = isFuture(method.returnType) ? 'await' : '';

    return '''
    @override
    ${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) $asyncModifier {
      final result = $awaitIfNeeded super.${method.name}(${paramsTemplate.generateParamsUsage()});

      ${_generateClearMaps()}

      return result;
    }
    ''';
  }

  String _generateClearMaps() {
    return [
      ...method.methodNames.map(
        (methodToClear) => "${getCacheMapName(methodToClear)}.clear();",
      ),
      ...method.ttlsToClear.map(
        (ttlToClearMethodName) =>
            "${getTtlMapName(ttlToClearMethodName)}.clear();",
      ),
      ...streamedCacheMethods?.map(
            (streamedMethod) => clearStreamedCache(streamedMethod),
          ) ??
          <String>[]
    ].join("\n");
  }
}
