import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  const _expectedAnnotatedTests = {
    'PositionalArguments',
    'OptionalArguments',
    'NamedArguments',
    'PositionalAndOptinalArguments',
    'PositionalAndNamesArguments',
  };

  final reader = await initializeLibraryReaderForDirectory(
    p.join('test', 'inputs'),
    'constructor_generation_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const CachedGenerator(config: Config()),
    expectedAnnotatedTests: _expectedAnnotatedTests,
  );
}
