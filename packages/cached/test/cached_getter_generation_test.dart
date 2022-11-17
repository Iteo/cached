import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  const _expectedAnnotatedTests = {
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
  };

  final reader = await initializeLibraryReaderForDirectory(
    p.join('test', 'inputs'),
    'cached_getter_generation_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const CachedGenerator(config: Config()),
    expectedAnnotatedTests: _expectedAnnotatedTests,
  );
}
