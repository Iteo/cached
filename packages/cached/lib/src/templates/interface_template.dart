import 'package:cached/src/models/class_with_cache.dart';

class InterfaceTemplate {
  InterfaceTemplate(this.classWithCache);

  final ClassWithCache classWithCache;

  String generate() {
    final constructor = classWithCache.constructor;
    final params = constructor.params;
    final name = classWithCache.name;
    final getters = params.map(
      (e) => '${e.type} get ${e.name};',
    );

    return '''
       abstract class _\$$name {
          ${getters.join('\n')}
       }
    ''';
  }
}
