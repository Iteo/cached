import 'package:cached_annotation/cached_annotation.dart';
import 'package:test/test.dart';

import '../utils/test_storage.dart';
import '../utils/test_storage_to_write.dart';
import '../utils/test_storage_with_data.dart';
import '../utils/test_utils.dart';
import 'direct_persistent_storage/cached_test_direct_persistent_storage.dart';

void main() {
  group(
    'DirectPersistentStorage',
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
            '_directPersistentCachedValueCached': {},
            '_anotherDirectPersistentCachedValueCached': {},
            '_directPersistentCachedListCached': {},
          },
        );
        final cachedClass = DirectPersistentCachedStorage(dataProvider);

        final firstResult = await cachedClass.directPersistentCachedValue();
        final secondResult = await cachedClass.directPersistentCachedValue();

        expect(firstResult, equals(secondResult));
      });

      test('return random data from a storage which does not save data',
          () async {
        PersistentStorageHolder.storage = TestStorageWithData(
          {
            '_directPersistentCachedValueCached': {},
            '_anotherDirectPersistentCachedValueCached': {},
            '_directPersistentCachedListCached': {},
          },
        );
        final cachedClass = DirectPersistentCachedStorage(dataProvider);

        final firstResult = await cachedClass.directPersistentCachedValue();
        final secondResult = await cachedClass.directPersistentCachedValue();

        expect(firstResult, isNot(equals(secondResult)));
      });
    },
  );
}
