import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:collection/collection.dart';

class CachedMethodTemplate {
  CachedMethodTemplate(
    this.method, {
    required this.methods,
    required this.useStaticCache,
    required this.isCacheStreamed,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final CachedMethod method;
  final Iterable<CachedMethod> methods;
  final AllParamsTemplate paramsTemplate;
  final bool useStaticCache;
  final bool isCacheStreamed;

  String generateSyncMap() {
    if (!method.syncWrite) {
      return '';
    }

    return '${_getStaticModifier()} final $_syncMapName = <String, Future<$_syncReturnType>>{};';
  }

  String generateCacheMap() {
    return '${_getStaticModifier()} final $_cacheMapName = <String, $_syncReturnType>{};';
  }

  String generateTtlMap() {
    if (method.ttl == null) {
      return '';
    }

    return '${_getStaticModifier()} final $_ttlMapName = <String, DateTime>{};';
  }

  String generateMethod() {
    final syncModifier = method.isGenerator && !method.isAsync ? 'sync' : '';
    final asyncModifier = _returnsFuture || method.isAsync ? 'async' : '';
    final generatorModifier = method.isGenerator ? '*' : '';
    final returnKeyword = method.isGenerator ? 'yield*' : 'return';
    final awaitIfNeeded = _returnsFuture ? 'await' : '';

    final ignoreCacheParam = method.params
        .firstWhereOrNull((element) => element.ignoreCacheAnnotation != null);
    final useCacheOnError =
        ignoreCacheParam?.ignoreCacheAnnotation?.useCacheOnError ?? false;

    final ignoreCacheCondition =
        ignoreCacheParam != null ? '|| ${ignoreCacheParam.name}' : '';
    return '''
@override
${method.returnType} ${method.name}(${paramsTemplate.generateParams()}) $syncModifier$asyncModifier$generatorModifier {
  ${_generateRemoveTtlLogic()}
  final cachedValue = $_cacheMapName["$_paramsKey"];
  if (cachedValue == null $ignoreCacheCondition) {
    ${_generateGetSyncedLogic()}

    final $_syncReturnType toReturn;
    try {
      final result = super.${method.name}(${paramsTemplate.generateParamsUsage()});
      ${method.syncWrite && _returnsFuture ? "$_syncMapName['$_paramsKey'] = result;" : ""}
      toReturn = $awaitIfNeeded result;
    } catch(_) {
      ${useCacheOnError ? "if (cachedValue != null) { return cachedValue; }" : ""}
      rethrow;
    } finally {
      ${method.syncWrite && _returnsFuture ? "$_syncMapName.remove('$_paramsKey');" : ""}
    }
    
    $_cacheMapName["$_paramsKey"] = toReturn;
    
    ${_generateStreamCall()}

    ${_generateLimitLogic()}
    ${_generateAddTtlLogic()}
    $returnKeyword toReturn;
  } else {
    $returnKeyword cachedValue;
  }
}

''';
  }

  String _getStaticModifier() {
    return useStaticCache ? 'static' : '';
  }

  String _generateGetSyncedLogic() {
    if (!method.syncWrite || !_returnsFuture) return '';

    return '''
final cachedFuture = $_syncMapName["$_paramsKey"];

if (cachedFuture != null) {
  return cachedFuture;
}
''';
  }

  String _generateRemoveTtlLogic() {
    if (method.ttl == null) return '';

    return '''
final now = DateTime.now();
final currentTtl = $_ttlMapName["$_paramsKey"];

if (currentTtl != null && currentTtl.isBefore(now)) {
  $_ttlMapName.remove("$_paramsKey");
  $_cacheMapName.remove("$_paramsKey");
}
''';
  }

  String _generateAddTtlLogic() {
    if (method.ttl == null) return '';

    return '''
$_ttlMapName["$_paramsKey"] = DateTime.now().add(const Duration(seconds: ${method.ttl}));
''';
  }

  String get _paramsKey => getParamKey(method.params);

  String get _cacheMapName => getCacheMapName(method.name);

  String get _ttlMapName => getTtlMapName(method.name);

  String get _syncMapName => '_${method.name}Sync';

  bool get _returnsFuture => isFuture(method.returnType);

  String get _syncReturnType => syncReturnType(method.returnType);

  String _generateLimitLogic() {
    if (method.limit == null) return '';

    return '''
if ($_cacheMapName.length > ${method.limit}) {
  $_cacheMapName.remove($_cacheMapName.entries.last.key);
}
''';
  }

  String _generateStreamCall() {
    return isCacheStreamed
        ? '''
    final streamController = ${getCacheStreamMapName(method.name)}["$_paramsKey"];
    if(streamController!=null) {
       streamController.sink.add(toReturn);
    }
    '''
        : '';
  }
}
