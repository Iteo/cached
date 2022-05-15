import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/templates/template.dart';

class MixinTemplate implements Template {
  MixinTemplate(this.classWithCache);

  final ClassWithCache classWithCache;

  @override
  String generate() {
    final getters = classWithCache.constructor.params
        .map((e) => '${e.type} get ${e.name};');

    return '''
mixin _\$${classWithCache.name} {
  ${getters.join('\n')}
}
''';
  }
}
