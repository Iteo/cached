import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  const expectedAnnotatedTests = {
    'VoidGetter',
    'FutureVoidGetter',
    'AbstractGetter',
    'Getter',
    'AsyncGet',
    'AsyncGeneratorGetter',
    'SyncGeneratorGetter',
    'CachedWithLimit',
    'CachedWithTtl',
    'AsyncSyncWrite',
    'SyncSyncWrite',
    'PersistentCachedGetter',
    'DirectPersistentCachedGetter',
    'InitOnCallPersistentCachedGetter',
  };

  final reader = await initializeLibraryReaderForDirectory(
    path.join('test', 'inputs'),
    'cached_getter_generation_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const CachedGenerator(config: Config()),
    expectedAnnotatedTests: expectedAnnotatedTests,
  );
}
