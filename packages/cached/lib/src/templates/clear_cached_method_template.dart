import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/utils/utils.dart';

class ClearCachedMethodTemplate {
  ClearCachedMethodTemplate(this.method);

  final ClearCachedMethod method;

  String generateMethod() {
    return '''
  @override
  void ${method.name}() => ${getCacheMapName(method.methodName)}.clear();
  ''';
  }
}
