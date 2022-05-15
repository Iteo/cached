import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/templates/class_template.dart';
import 'package:cached/src/templates/mixin_template.dart';
import 'package:cached/src/templates/template.dart';

class FileTemeplate implements Template {
  FileTemeplate(ClassWithCache classWithCache)
      : mixinTemplate = MixinTemplate(classWithCache),
        classTemplate = ClassTemplate(classWithCache);

  final MixinTemplate mixinTemplate;
  final ClassTemplate classTemplate;

  @override
  String generate() {
    return [mixinTemplate, classTemplate].map((e) => e.generate()).join('\n\n');
  }
}
