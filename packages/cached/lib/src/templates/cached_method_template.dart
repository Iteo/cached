import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:collection/collection.dart';

final _futureRegexp = RegExp(r'^Future<(.+)>$');

class CachedMethodTemplate {
  CachedMethodTemplate(
    this.method, {
    required this.useStaticCache,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final CachedMethod method;
  final AllParamsTemplate paramsTemplate;
  final bool useStaticCache;

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
    final syncModifier = method.isGenerator && !_returnsFuture ? 'sync' : '';
    final asyncModifier = _returnsFuture ? 'async' : '';
    final generatorModifier = method.isGenerator ? '*' : '';
    final ignoreCacheParam = method.params
        .firstWhereOrNull((element) => element.ignoreCacheAnnotation != null);
    final useCacheOnError =
        ignoreCacheParam?.ignoreCacheAnnotation?.useCacheOnError ?? false;
    final awaitIfNeeded = _returnsFuture ? 'await' : '';

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

    ${_generateLimitLogic()}
    ${_generateAddTtlLogic()}
    return toReturn;
  }

  return cachedValue;
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

  String get _paramsKey => method.params
      .where((element) => element.ignoreCacheAnnotation == null)
      .map((e) => '\${${e.name}.hashCode}')
      .join();

  String get _cacheMapName => getCacheMapName(method.name);

  String get _ttlMapName => '_${method.name}Ttl';

  String get _syncMapName => '_${method.name}Sync';

  bool get _returnsFuture {
    return _futureRegexp.hasMatch(method.returnType);
  }

  String get _syncReturnType {
    if (_futureRegexp.hasMatch(method.returnType)) {
      return _futureRegexp.firstMatch(method.returnType)?.group(1) ?? '';
    }

    return method.returnType;
  }

  String _generateLimitLogic() {
    if (method.limit == null) return '';

    return '''
if ($_cacheMapName.length >= ${method.limit}) {
  $_cacheMapName.remove($_cacheMapName.entries.last.key);
}
''';
  }
}
