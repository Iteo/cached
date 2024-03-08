import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/utils/common_generator.dart';
import 'package:cached/src/utils/persistent_storage_holder_texts.dart';
import 'package:cached/src/utils/type_cast_appender.dart';
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

  String generateAdditionalCacheCondition() => '';

  String get paramsKey;

  String get _cacheMapName => getCacheMapName(function.name);

  String get _ttlMapName => getTtlMapName(function.name);

  String get _syncMapName => '_${function.name}Sync';

  bool get _returnsFuture => isFuture(function.returnType);

  String get _syncReturnType => syncReturnType(function.returnType);

  String get _returnKeyword => function.isGenerator ? 'yield*' : 'return';

  String get _toReturnVariable => 'toReturn';

  bool get _initOnCall => function.initOnCall ?? false;

  bool get _shouldUsePersistentStorage => function.persistentStorage ?? false;
  bool get _shouldUseDirectPersistentStorage =>
      function.directPersistentStorage ?? false;

  bool get _hasTtl => function.ttl != null;

  String generate() {
    final generatorModifier = function.isGenerator ? '*' : '';

    final isGeneratorOrAsync = function.isGenerator && !function.isAsync;
    final syncGeneratorModifier = isGeneratorOrAsync ? 'sync' : '';

    final returnsFutureOrIsAsync = _returnsFuture || function.isAsync;
    final checkIfShouldCacheMethod = function.checkIfShouldCacheMethod;
    final shouldCacheAsync = checkIfShouldCacheMethod?.isAsync;
    final cacheAsync = shouldCacheAsync == true;
    final useAsyncKeyword = returnsFutureOrIsAsync || cacheAsync;
    final asyncModifier = useAsyncKeyword ? 'async' : '';

    final generatedDefinition = generateDefinition();
    final usage = generateUsage();

    return '''
       @override
       ${function.returnType} $generatedDefinition $syncGeneratorModifier$asyncModifier$generatorModifier {
          ${_generateInitOnCallCache()}
          ${_generateStorageAwait()}
                 
          ${_generateRemoveTtlLogic()}
          
          final cachedValue = ${_test()};
          if (${_generateConditionForCache()} ${generateAdditionalCacheCondition()}) {
             ${_generateGetSyncedLogic()}
   
             final $_syncReturnType $_toReturnVariable;
             try {
                  final result = super.$usage;
                  ${function.syncWrite && _returnsFuture ? '$_syncMapName["$paramsKey"] = result;' : ""}
                  $_toReturnVariable = ${_returnsFuture ? 'await' : ''} result;
             } catch(_) {
                  ${generateOnCatch()}
             } finally {
                  ${function.syncWrite && _returnsFuture ? "$_syncMapName.remove('$paramsKey');" : ""}
             }
   
             ${_generateCheckIfShouldCache()}
   
             ${_generateUpdateCacheMap()}
   
             ${_generateStreamCall()}
   
             ${_generateLimitLogic()}
             ${_generateAddTtlLogic()}
       
             ${_generateCacheWrite()}
             ${_generateTtlWrite()}
       
             $_returnKeyword $_toReturnVariable;
          } else {
             ${_generateCachedValueReturn()}
          }
        }
   ''';
  }

  String _generateCachedValueReturn() {
    final code = '$_returnKeyword cachedValue';
    if (!_shouldUsePersistentStorage && !_shouldUseDirectPersistentStorage) {
      return '$code;';
    }

    final appender = TypeCastAppender();
    return appender.wrapWithTryCatchAndAddGenericCast(
      codeToWrap: _shouldUseDirectPersistentStorage ? "$code['']" : code,
      returnType: function.returnType,
    );
  }

  String generateSyncMap() {
    if (!function.syncWrite) {
      return '';
    }

    final staticModifier = _getStaticModifier();
    return '$staticModifier final $_syncMapName = <String, Future<$_syncReturnType>>{};';
  }

  String generateCacheMap() {
    final staticModifier = _getStaticModifier();

    if (_shouldUseDirectPersistentStorage) {
      return '';
    }

    if (_shouldUsePersistentStorage && !_initOnCall) {
      return '$staticModifier late final Map<String, dynamic> $_cacheMapName;';
    }

    if (_shouldUsePersistentStorage && _initOnCall) {
      return '$staticModifier Map<String, dynamic>? $_cacheMapName = null;';
    }

    return '$staticModifier final $_cacheMapName = <String, $_syncReturnType>{};';
  }

  String generateTtlMap() {
    final staticModifier = _getStaticModifier();

    if (!_hasTtl) {
      return '';
    }

    if (_shouldUsePersistentStorage) {
      return '$staticModifier late final $_ttlMapName;';
    }

    return '$staticModifier final $_ttlMapName = <String, String>{};';
  }

  String generateAsyncPersistentStorageInit() {
    final buffer = StringBuffer();
    if (_shouldUsePersistentStorage) {
      final cacheInit = _getCacheInit();
      buffer.writeln(cacheInit);
      buffer.writeln('\n');
    }

    if (_shouldUsePersistentStorage && _hasTtl) {
      final ttlInit = _getTtlInit();
      buffer.writeln(ttlInit);
      buffer.writeln('\n');
    }

    return buffer.toString();
  }

  String _getCacheInitOnCall() {
    return '''
      if($_cacheMapName == null) {
        ${_getCacheInit()}
        }
    ''';
  }

  String _getCacheInit() {
    final init = '''
      final cachedMap = $readCodeText('$_cacheMapName');
      
      cachedMap.forEach((_, value) {
        if (value is! $_syncReturnType) throw TypeError();
      });
      
      
      $_cacheMapName = cachedMap;
    ''';

    return _wrapWithTryCatchAndAssignEmptyMap(
      init,
      _cacheMapName,
    );
  }

  String _getTtlInit() {
    final init = "$_ttlMapName = $readCodeText('$_ttlMapName');";
    return _wrapWithTryCatchAndAssignEmptyMap(
      init,
      _ttlMapName,
    );
  }

  String _wrapWithTryCatchAndAssignEmptyMap(
    String dangerousInit,
    String mapName,
  ) {
    return '''
       try {
          $dangerousInit
       } catch (e) {
          $mapName = <String, dynamic>{};
       }
    ''';
  }

  String _getStaticModifier() {
    return useStaticCache ? 'static' : '';
  }

  String _generateConditionForCache() {
    if (_shouldUseDirectPersistentStorage) {
      return "cachedValue.isEmpty && cachedValue[''] == null";
    }

    return 'cachedValue == null';
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

  String _generateInitOnCallCache() {
    if (_shouldUsePersistentStorage && _initOnCall) {
      return _getCacheInitOnCall();
    }

    return '';
  }

  String _generateStorageAwait() {
    if (_shouldUsePersistentStorage && function.initOnCall == false) {
      return CommonGenerator.awaitCompleterFutureText;
    }

    return '';
  }

  String _generateRemoveTtlLogic() {
    if (!_hasTtl) return '';

    return '''
       final now = DateTime.now();
       final cachedTtl = $_ttlMapName["$paramsKey"];
       final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

       if (currentTtl != null && currentTtl.isBefore(now)) {
          $_ttlMapName.remove("$paramsKey");
          $_cacheMapName.remove("$paramsKey");
       }
    ''';
  }

  String _test() {
    if (_shouldUseDirectPersistentStorage) {
      return "$readCodeText('$_cacheMapName')";
    } else if (_initOnCall) {
      return '$_cacheMapName!["$paramsKey"]';
    }

    return '$_cacheMapName["$paramsKey"]';
  }

  String _generateAddTtlLogic() {
    if (!_hasTtl) return '';

    return '''
       const duration = Duration(seconds: ${function.ttl});
       $_ttlMapName["$paramsKey"] = DateTime.now().add(duration).toIso8601String();
    ''';
  }

  String _generateCacheWrite() {
    if (_shouldUsePersistentStorage && !_initOnCall) {
      return "$writeCodeText('$_cacheMapName', $_cacheMapName);";
    } else if (_shouldUseDirectPersistentStorage) {
      return "$writeCodeText('$_cacheMapName', {'': toReturn});";
    } else if (_shouldUseDirectPersistentStorage && _initOnCall) {
      return "$writeCodeText('$_cacheMapName', $_cacheMapName!);";
    }

    return '';
  }

  String _generateTtlWrite() {
    if (_hasTtl && _shouldUsePersistentStorage) {
      return "$writeCodeText('$_ttlMapName', $_ttlMapName);";
    }

    return '';
  }

  String _generateLimitLogic() {
    if (function.limit == null) return '';

    return '''
       if ($_cacheMapName.length > ${function.limit}) {
          $_cacheMapName.remove($_cacheMapName.entries.first.key);
       }
    ''';
  }

  String _generateUpdateCacheMap() {
    if (_shouldUseDirectPersistentStorage) {
      return '';
    }

    if (_initOnCall) {
      return '$_cacheMapName!["$paramsKey"] = $_toReturnVariable;';
    }
    return '$_cacheMapName["$paramsKey"] = $_toReturnVariable;';
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
           ),
      );
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
