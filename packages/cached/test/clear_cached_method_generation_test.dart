import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  const expectedAnnotatedTests = {
    'NoTargetMethod',
    'MultipleClearMethods',
    'InvalidName',
    'InvalidReturnType',
    'InvalidReturnTypeNonAbstract',
    'AbstractWithParams',
    'ValidAbstractWithTtl',
    'ValidAbstract',
    'ValidAbstractFuture',
    'ValidAbstractWithTwoCachedMethod',
    'ValidReturnFutureBool',
    'ValidReturnFutureVoid',
  };

  final reader = await initializeLibraryReaderForDirectory(
    path.join('test', 'inputs'),
    'clear_cached_method_generation_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const CachedGenerator(config: Config()),
    expectedAnnotatedTests: expectedAnnotatedTests,
  );
}
