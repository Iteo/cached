import 'package:cached_annotation/cached_annotation.dart';
import 'package:test/test.dart';

import '../utils/test_storage.dart';
import '../utils/test_storage_to_write.dart';
import '../utils/test_storage_with_data.dart';
import '../utils/test_utils.dart';
import 'lazy_persistent_storage/cached_test_lazy_persistent_storage.dart';

void main() {
  group(
    'LazyPersistentStorage',
    () {
      late TestDataProvider dataProvider;

      setUp(() {
        dataProvider = TestDataProvider();
      });

      tearDownAll(() {
        PersistentStorageHolder.storage = TestStorage();
      });

      test('return same data from storage which save data', () async {
        PersistentStorageHolder.storage = TestStorageWithWrite(
          {
            '_lazyPersistentCachedValueCached': {},
            '_anotherLazyPersistentCachedValueCached': {},
            '_lazyPersistentCachedListCached': {},
          },
        );
        final cachedClass = LazyPersistentCachedStorage(dataProvider);

        final firstResult = await cachedClass.lazyPersistentCachedValue();
        final secondResult = await cachedClass.lazyPersistentCachedValue();

        expect(firstResult, equals(secondResult));
      });

      test('return random data from a storage which does not save data',
          () async {
        PersistentStorageHolder.storage = TestStorageWithData(
          {
            '_lazyPersistentCachedValueCached': {},
            '_anotherLazyPersistentCachedValueCached': {},
            '_lazyPersistentCachedListCached': {},
          },
        );
        final cachedClass = LazyPersistentCachedStorage(dataProvider);

        final firstResult = await cachedClass.lazyPersistentCachedValue();
        final secondResult = await cachedClass.lazyPersistentCachedValue();

        expect(firstResult, isNot(equals(secondResult)));
      });
    },
  );
}
