import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  const expectedAnnotatedTests = {
    'ShouldCacheIncompatibleTypes',
    'ShouldCacheAsyncAnnotated',
    'ShouldCacheAsyncCondition',
    'ShouldCacheReturnsVoid',
    'AlwaysCache',
    'NeverCache',
    'Parameters',
    'AnnotatedMethodHasKey',
    'StaticCache',
  };

  final reader = await initializeLibraryReaderForDirectory(
    path.join('test', 'inputs'),
    'should_cache_generation_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const CachedGenerator(config: Config()),
    expectedAnnotatedTests: expectedAnnotatedTests,
  );
}
