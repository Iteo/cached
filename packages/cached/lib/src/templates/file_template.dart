import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/templates/class_template.dart';
import 'package:cached/src/templates/interface_template.dart';

class FileTemeplate {
  FileTemeplate(ClassWithCache classWithCache)
      : mixinTemplate = InterfaceTemplate(classWithCache),
        classTemplate = ClassTemplate(classWithCache);

  final InterfaceTemplate mixinTemplate;
  final ClassTemplate classTemplate;

  String generate() {
    return '''
${mixinTemplate.generate()}

${classTemplate.generate()}
''';
  }
}
