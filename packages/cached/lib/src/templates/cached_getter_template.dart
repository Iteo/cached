import 'package:cached/src/models/cached_getter.dart';
import 'package:cached/src/templates/cached_function_template.dart';

class CachedGetterTemplate extends CachedFunctionTemplate {
  CachedGetterTemplate(
    CachedGetter getter, {
    required bool useStaticCache,
    required bool isCacheStreamed,
  }) : super(
          getter,
          useStaticCache: useStaticCache,
          isCacheStreamed: isCacheStreamed,
        );

  @override
  String get paramsKey => "";

  @override
  String generateDefinition() {
    return "get ${function.name}";
  }

  @override
  String generateUsage() {
    return function.name;
  }

  @override
  String generateOnCatch() {
    return 'rethrow;';
  }
}
