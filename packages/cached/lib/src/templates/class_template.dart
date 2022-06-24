import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/templates/cached_method_template.dart';
import 'package:cached/src/templates/clear_all_cached_method_template.dart';
import 'package:cached/src/templates/clear_cached_method_template.dart';

class ClassTemplate {
  ClassTemplate(this.classWithCache);

  final ClassWithCache classWithCache;

  String generate() {
    final methodTemplates = classWithCache.methods.map(
      (e) => CachedMethodTemplate(
        e,
        useStaticCache: classWithCache.useStaticCache,
      ),
    );

    final clearMethodTemplates = classWithCache.clearMethods.map(
      (e) => ClearCachedMethodTemplate(e),
    );

    final clearAllMethodTemplate = ClearAllCachedMethodTemplate(
      method: classWithCache.clearAllMethod,
      cachedMethods: classWithCache.methods,
    );

    final constructorParamTemplates =
        AllParamsTemplate(classWithCache.constructor.params);

    return '''
class ${_generatedClassName()} ${_inheritanceKeyword()} ${_extendedClass()} implements _\$${classWithCache.name} {
  ${_generatedClassName()}(${constructorParamTemplates.generateThisParams()})${_superConstructorCall(constructorParamTemplates)};

  ${constructorParamTemplates.generateFields(addOverrideAnnotation: true)}

  ${methodTemplates.map((e) => e.generateSyncMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateCacheMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateTtlMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateMethod()).join('\n\n')}

  ${clearMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}

  ${clearAllMethodTemplate.generateMethod()}
}
''';
  }

  String _generatedClassName() => '${_classPrefix()}${classWithCache.name}';

  String _classPrefix() => classWithCache.isRetrofitClass ? '_Cached' : '_';

  String _inheritanceKeyword() =>
      classWithCache.isRetrofitClass ? 'extends' : 'with';

  String _extendedClass() => classWithCache.isRetrofitClass
      ? '_${classWithCache.name}'
      : classWithCache.name;

  String _superConstructorCall(AllParamsTemplate allParamsTemplate) =>
      classWithCache.isRetrofitClass
          ? ': super(${allParamsTemplate.generateParamsUsage()})'
          : '';
}
