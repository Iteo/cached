import 'package:cached/src/models/clear_cached_method.dart';

class ClearCachedMethodTemplate {
  ClearCachedMethodTemplate(this.method);

  final ClearCachedMethod method;

  String generateMethod() {
    return '''
  @override
  void ${method.name}() => $_cacheMapName.clear();
  ''';
  }

  String get _cacheMapName => '_${method.methodName}Cached';
}
