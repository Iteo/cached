import 'package:cached/src/models/class_with_cache.dart';

class InterfaceTemplate {
  InterfaceTemplate(this.classWithCache);

  final ClassWithCache classWithCache;

  String generate() {
    final getters = classWithCache.constructor.params
        .map((e) => '${e.type} get ${e.name};');

    return '''
abstract class _\$${classWithCache.name} {
  ${getters.join('\n')}
}
''';
  }
}
