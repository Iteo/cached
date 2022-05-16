import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/templates/cached_method_template.dart';

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

    final constructorParamTemplates =
        AllParamsTemplate(classWithCache.constructor.params);

    return '''
class _${classWithCache.name} with ${classWithCache.name} implements _\$${classWithCache.name} {
  const _${classWithCache.name}(${constructorParamTemplates.generateThisParams()});

  ${constructorParamTemplates.generateFields(addOverrideAnnotation: true)}

  ${methodTemplates.map((e) => e.generateSyncMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateCacheMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateTtlMap()).join('\n')}

  ${methodTemplates.map((e) => e.generateMethod()).join('\n\n')}
}
''';
  }
}
