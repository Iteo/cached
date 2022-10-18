import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class CachePeekMethodTemplate {
  CachePeekMethodTemplate(
    this.method, {
    required this.className,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final CachePeekMethod method;
  final String className;
  final AllParamsTemplate paramsTemplate;

  String generateMethod() {
    return '''
@override
${method.returnType}? ${method.name}(${paramsTemplate.generateParams()})  {
  final paramsKey = "${getParamKey(method.params)}";

  return ${getCacheMapName(method.targetMethodName)}[paramsKey];
}
    ''';
  }
}
