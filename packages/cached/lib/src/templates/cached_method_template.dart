import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/utils/utils.dart';

abstract class CachedMethodTemplate {
  CachedMethodTemplate(
    this.function, {
    required this.useStaticCache,
    required this.isCacheStreamed,
  });

  final CachedFunction function;
  final bool useStaticCache;
  final bool isCacheStreamed;

  String generateDefinition();

  String generateUsage();

  String generateOnCatch();

  String generateAdditionalCacheCondition() => "";

  String get paramsKey;

  String generateSyncMap() {
    if (!function.syncWrite) {
      return '';
    }

    return '${_getStaticModifier()} final $_syncMapName = <String, Future<$_syncReturnType>>{};';
  }

  String generateCacheMap() {
    return '${_getStaticModifier()} final $_cacheMapName = <String, $_syncReturnType>{};';
  }

  String generateTtlMap() {
    if (function.ttl == null) {
      return '';
    }

    return '${_getStaticModifier()} final $_ttlMapName = <String, DateTime>{};';
  }

  String generate() {
    final syncGeneratorModifier =
        function.isGenerator && !function.isAsync ? 'sync' : '';
    final asyncModifier = (_returnsFuture ||
            function.isAsync ||
            function.checkIfShouldCacheMethod?.isAsync == true)
        ? 'async'
        : '';
    final generatorModifier = function.isGenerator ? '*' : '';

    return '''
@override
${function.returnType} ${generateDefinition()} $syncGeneratorModifier$asyncModifier$generatorModifier {

  
  ${_generateRemoveTtlLogic()}
  final cachedValue = $_cacheMapName["$paramsKey"];
  if (cachedValue == null ${generateAdditionalCacheCondition()}) {
    ${_generateGetSyncedLogic()}

    final $_syncReturnType $_toReturnVariable;
    try {
      final result = super.${generateUsage()};
      ${function.syncWrite && _returnsFuture ? "$_syncMapName['$paramsKey'] = result;" : ""}
      $_toReturnVariable = ${_returnsFuture ? 'await' : ''} result;
    } catch(_) {
      ${generateOnCatch()}
    } finally {
      ${function.syncWrite && _returnsFuture ? "$_syncMapName.remove('$paramsKey');" : ""}
    }

    ${_generateCheckIfShouldCache()}

    $_cacheMapName["$paramsKey"] = $_toReturnVariable;

    ${_generateStreamCall()}

    ${_generateLimitLogic()}
    ${_generateAddTtlLogic()}
    $_returnKeyword $_toReturnVariable;
  } else {
    $_returnKeyword cachedValue;
  }
}

''';
  }

  String _getStaticModifier() {
    return useStaticCache ? 'static' : '';
  }

  String _generateGetSyncedLogic() {
    if (!function.syncWrite || !_returnsFuture) return '';

    return '''
final cachedFuture = $_syncMapName["$paramsKey"];

if (cachedFuture != null) {
  return cachedFuture;
}
''';
  }

  String _generateRemoveTtlLogic() {
    if (function.ttl == null) return '';

    return '''
final now = DateTime.now();
final currentTtl = $_ttlMapName["$paramsKey"];

if (currentTtl != null && currentTtl.isBefore(now)) {
  $_ttlMapName.remove("$paramsKey");
  $_cacheMapName.remove("$paramsKey");
}
''';
  }

  String _generateAddTtlLogic() {
    if (function.ttl == null) return '';

    return '''
$_ttlMapName["$paramsKey"] = DateTime.now().add(const Duration(seconds: ${function.ttl}));
''';
  }

  String get _cacheMapName => getCacheMapName(function.name);

  String get _ttlMapName => getTtlMapName(function.name);

  String get _syncMapName => '_${function.name}Sync';

  bool get _returnsFuture => isFuture(function.returnType);

  String get _syncReturnType => syncReturnType(function.returnType);

  String get _returnKeyword => function.isGenerator ? 'yield*' : 'return';

  String get _toReturnVariable => 'toReturn';

  String _generateLimitLogic() {
    if (function.limit == null) return '';

    return '''
if ($_cacheMapName.length > ${function.limit}) {
  $_cacheMapName.remove($_cacheMapName.entries.last.key);
}
''';
  }

  String _generateStreamCall() {
    if (!isCacheStreamed) {
      return '';
    }
    return '''
          ${getCacheStreamControllerName(function.name)}.sink.add(MapEntry(StreamEventIdentifier(
              ${useStaticCache ? '' : 'instance: this,'}
              paramsKey: "$paramsKey",
            ),
            $_toReturnVariable,
          ));
          ''';
  }

  String _generateCheckIfShouldCache() {
    final checkIfShouldCacheMethod = function.checkIfShouldCacheMethod;
    if (checkIfShouldCacheMethod == null) {
      return '';
    }

    return '''
      final shouldCache = ${checkIfShouldCacheMethod.isAsync ? 'await' : ''} ${checkIfShouldCacheMethod.name}($_toReturnVariable);
      if (!shouldCache) {
         $_returnKeyword $_toReturnVariable;
      }
    ''';
  }
}
