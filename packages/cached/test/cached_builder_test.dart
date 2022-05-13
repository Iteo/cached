import 'package:cached/cached.dart';
import 'package:generator_test/generator_test.dart';
import 'package:test/scaffolding.dart';



void main() {
  test('successful generation', () async {
    final generator = SuccessGenerator.fromBuilder(
      'example',
      cachedBuilder,
      compareWithFixture: false,
    );

    await generator.test();
  });
}
