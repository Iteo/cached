import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/source_gen_test.dart';

@ShouldThrow('[ERROR] Class NonAbastractClass need to be abstract')
@withCache
class NonAbastractClass {}

@ShouldThrow(
    '[ERROR] Class NotFactoryConstructor need to have one factory constructor')
@withCache
abstract class NotFactoryConstructor {
  NotFactoryConstructor();
}

@ShouldThrow(
  '[ERROR] To many constructors in MultipleConstructors class. Class can have '
  'only one constructor',
)
@withCache
abstract class MultipleConstructors {
  factory MultipleConstructors() = _MultipleConstructors;

  factory MultipleConstructors.other() = _MultipleConstructorsOther;
}

@ShouldGenerate(
  r'''
abstract class _$ValidClass {}

class _ValidClass with ValidClass implements _$ValidClass {
  _ValidClass();
}
''',
)
@withCache
abstract class ValidClass {
  factory ValidClass() = _ValidClass;
}
