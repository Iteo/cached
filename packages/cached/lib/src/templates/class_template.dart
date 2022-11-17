import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/templates/cache_peek_method_template.dart';
import 'package:cached/src/templates/cached_getter_template.dart';
import 'package:cached/src/templates/cached_method_template.dart';
import 'package:cached/src/templates/clear_all_cached_method_template.dart';
import 'package:cached/src/templates/clear_cached_method_template.dart';
import 'package:cached/src/templates/deletes_cache_method_template.dart';
import 'package:cached/src/templates/streamed_method_template.dart';
import 'package:collection/collection.dart';

class ClassTemplate {
  ClassTemplate(this.classWithCache);

  final ClassWithCache classWithCache;

  String generate() {
    final classMethods = classWithCache.methods;

    final methodTemplates = classMethods.map(
      (e) => CachedMethodTemplate(
        e,
        useStaticCache: classWithCache.useStaticCache,
        isCacheStreamed: classWithCache.streamedCacheMethods
            .any((s) => s.targetMethodName == e.name),
      ),
    );

    final getterTemplates = classWithCache.getters.map(
      (e) => CachedGetterTemplate(
        e,
        useStaticCache: classWithCache.useStaticCache,
        isCacheStreamed: classWithCache.streamedCacheMethods
            .any((s) => s.targetMethodName == e.name),
      ),
    );

    final streamedCacheMethodTemplates =
        classWithCache.streamedCacheMethods.map(
      (e) => StreamedCacheMethodTemplate(
        e,
        useStaticCache: classWithCache.useStaticCache,
        className: classWithCache.name,
      ),
    );

    final clearMethodTemplates = classWithCache.clearMethods.map(
      (e) => ClearCachedMethodTemplate(
        e,
        streamedCacheMethod:
            classWithCache.streamedCacheMethods.firstWhereOrNull(
          (m) => m.targetMethodName == e.name,
        ),
      ),
    );

    final clearAllMethodTemplate = ClearAllCachedMethodTemplate(
      method: classWithCache.clearAllMethod,
      cachedMethods: classMethods,
      cachedGetters: classWithCache.getters,
      streamedCacheMethods: classWithCache.streamedCacheMethods,
    );

    final cachePeekMethodTemplates = classWithCache.cachePeekMethods.map(
      (e) => CachePeekMethodTemplate(
        e,
        className: classWithCache.name,
      ),
    );

    final constructorParamTemplates =
        AllParamsTemplate(classWithCache.constructor.params);

    final deletesCacheMethodTemplates = classWithCache.deletesCacheMethods.map(
      (method) => DeletesCacheMethodTemplate(
        method,
        classWithCache.streamedCacheMethods
            .where(
              (streamedMethod) =>
                  method.methodNames.contains(streamedMethod.targetMethodName),
            )
            .toList(),
      ),
    );

    return '''
class _${classWithCache.name} with ${classWithCache.name} implements _\$${classWithCache.name} {
  _${classWithCache.name}(${constructorParamTemplates.generateThisParams()});

  ${constructorParamTemplates.generateFields(addOverrideAnnotation: true)}

  ${methodTemplates.map((e) => e.generateSyncMap()).join('\n')}
  ${getterTemplates.map((e) => e.generateSyncMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateCacheMap()).join('\n')}
  ${getterTemplates.map((e) => e.generateCacheMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateTtlMap()).join('\n')}
  ${getterTemplates.map((e) => e.generateTtlMap()).join('\n')}

  ${streamedCacheMethodTemplates.map((e) => e.generateStreamMap()).join('\n')}

  ${methodTemplates.map((e) => e.generate()).join('\n\n')}
  ${getterTemplates.map((e) => e.generate()).join('\n\n')}

  ${streamedCacheMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}

  ${clearMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}

  ${cachePeekMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}

  ${clearAllMethodTemplate.generateMethod()}

  ${deletesCacheMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}
}
''';
  }
}
