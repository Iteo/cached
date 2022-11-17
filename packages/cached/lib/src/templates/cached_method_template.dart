import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/templates/cached_function_template.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:collection/collection.dart';

class CachedMethodTemplate extends CachedFunctionTemplate {
  CachedMethodTemplate(
    this.method, {
    required bool useStaticCache,
    required bool isCacheStreamed,
  })  : paramsTemplate = AllParamsTemplate(method.params),
        super(
          method,
          useStaticCache: useStaticCache,
          isCacheStreamed: isCacheStreamed,
        );

  final AllParamsTemplate paramsTemplate;
  final CachedMethod method;

  Param? get ignoreCacheParam => method.params
      .firstWhereOrNull((element) => element.ignoreCacheAnnotation != null);

  @override
  String get paramsKey => getParamKey(method.params);

  @override
  String generateDefinition() {
    return "${function.name}(${paramsTemplate.generateParams()})";
  }

  @override
  String generateUsage() {
    return "${function.name}(${paramsTemplate.generateParamsUsage()})";
  }

  @override
  String generateAdditionalCacheCondition() {
    final ignoreCacheParam = this.ignoreCacheParam;

    final ignoreCacheCondition =
        ignoreCacheParam != null ? '|| ${ignoreCacheParam.name}' : '';

    return ignoreCacheCondition;
  }

  @override
  String generateOnCatch() {
    final useCacheOnError =
        ignoreCacheParam?.ignoreCacheAnnotation?.useCacheOnError ?? false;
    return '${useCacheOnError ? "if (cachedValue != null) { return cachedValue;\n }" : ""}rethrow;';
  }
}
