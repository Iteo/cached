import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/templates/template.dart';
import 'package:collection/collection.dart';

const _ttlMapName = '_ttlMap';

class ClassTemplate implements Template {
  ClassTemplate(this.classWithCache);

  final ClassWithCache classWithCache;

  @override
  String generate() {
    return '''
class _${classWithCache.name} extends ${classWithCache.name} {
  const _${classWithCache.name}(${classWithCache.constructor.params.generateParams()});

  ${classWithCache.constructor.params.generateFields()}

  ${classWithCache.methods.generateCacheMaps(useStatic: classWithCache.useStaticCache)}

  ${classWithCache.methods.generateSyncMaps(useStatic: classWithCache.useStaticCache)}

  ${classWithCache.methods.generateTtlMap(useStatic: classWithCache.useStaticCache)}

  ${classWithCache.methods.generateMethods()}
}
''';
  }
}

// Powerful bool extension PDK
extension on bool {
  String tryStatic() => this ? 'static' : '';
}

extension on Iterable<CachedMethod> {
  String generateTtlMap({bool useStatic = false}) {
    final needTtl = any((element) => element.ttl != null);
    if (needTtl) {
      return 'final ${useStatic.tryStatic()} $_ttlMapName = Map<String, Timer>();';
    }
    return '';
  }

  String generateSyncMaps({bool useStatic = false}) {
    return where((e) => e.returnsFuture && e.syncWrite)
        .map(
          (e) =>
              'final ${useStatic.tryStatic()} ${e.syncMapName} = Map<String, Future<${e.syncReturnType}>>();',
        )
        .join('\n');
  }

  String generateCacheMaps({bool useStatic = false}) {
    return map(
      (e) =>
          'final ${useStatic.tryStatic()} ${e.cacheMapName} = Map<String, ${e.syncReturnType}>();',
    ).join('\n');
  }

  String generateMethods() {
    return map((e) => e.generateMethod()).join('\n\n');
  }
}

extension on CachedMethod {
  String get cacheMapName => '_${name}Cached';

  String get syncMapName => '_${name}Sync';

  bool get returnsFuture {
    final futureRegexp = RegExp(r'^Future<(.+)>$');
    return futureRegexp.hasMatch(returnType);
  }

  String get syncReturnType {
    final futureRegexp = RegExp(r'^Future<(.+)>$');
    if (futureRegexp.hasMatch(returnType)) {
      return futureRegexp.firstMatch(returnType)?.group(1) ?? '';
    }

    return returnType;
  }

  String generateLimitLogic() {
    if (limit == null) return '';

    return '''
if ($cacheMapName.length >= $limit) {
  $cacheMapName.remove($cacheMapName.entries.last.key);
}
''';
  }

  String generateMethod() {
    final syncModifier = isGenerator && !returnsFuture ? 'sync' : '';
    final asyncModifier = returnsFuture ? 'async' : '';
    final generatorModifier = isGenerator ? '*' : '';
    final ignoreCacheParam = params
        .firstWhereOrNull((element) => element.ignoreCacheAnnotation != null);
    final useCacheOnError =
        ignoreCacheParam?.ignoreCacheAnnotation?.useCacheOnError ?? false;
    final awaitIfNeeded = returnsFuture ? 'await' : '';

    final ignoreCacheCondition =
        ignoreCacheParam != null ? '|| ${ignoreCacheParam.name}' : '';

    return '''
@override
$returnType $name(${params.generateParams()}) $syncModifier$asyncModifier$generatorModifier {
  final cachedValue = $cacheMapName[$paramsKey];
  if (cachedValue == null $ignoreCacheCondition) {
    ${generateGetSyncedLogic()}

    final $syncReturnType toReturn;
    try {
      final result = super.$name(${params.useParams()});
      ${syncWrite && returnsFuture ? "$syncMapName[$paramsKey];" : ""}
      toReturn = $awaitIfNeeded result;
    } catch(_) {
      ${useCacheOnError ? "if (cachedValue != null) { return cachedValue; }" : ""}
      rethrow;
    } finally {
      ${syncWrite && returnsFuture ? "$syncMapName.remove($paramsKey);" : ""} 
    }

    ${generateLimitLogic()}
    ${generateTtlLogic()}
    return toReturn;
  }

  return cachedValue;
}
''';
  }

  String generateGetSyncedLogic() {
    if (!syncWrite || !returnsFuture) return '';

    return '''
final cachedFuture = $syncMapName[$paramsKey];

if (cachedFuture != null) {
  return cachedFuture;
}
''';
  }

  String generateTtlLogic() {
    if (ttl == null) return '';

    return '''
final key = "$name$paramsKey";
$_ttlMapName[key]?.cancel();
$_ttlMapName[key] = Timer(const Duration(seconds: $ttl), () {
  $cacheMapName[$paramsKey] = null;
  $_ttlMapName[key]?.cancel();
  $_ttlMapName[key] = null;
});
''';
  }

  String get paramsKey => params.map((e) => '\${${e.name}.hashCode}').join();
}

extension on Iterable<Param> {
  String generateFields() {
    return map((e) => 'final ${e.typeWithName};').join('\n');
  }

  String generateParams() {
    final positionalParams =
        where((element) => element.isPositional).map((e) => e.typeWithName);
    final namedParams =
        where((element) => element.isNamed).map((e) => e.typeWithName);
    final joinedNamed = namedParams.isEmpty ? '' : '{${namedParams.join(',')}}';

    return [positionalParams.join(','), joinedNamed].join(',');
  }

  String useParams() {
    final positionalParams =
        where((element) => element.isPositional).map((e) => e.name).join(',');
    final namedParams = where((element) => element.isNamed)
        .map((e) => '${e.name}: ${e.name}')
        .join(',');

    return [positionalParams, namedParams].join(',');
  }
}
