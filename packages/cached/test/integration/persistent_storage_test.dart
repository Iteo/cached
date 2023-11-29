import 'package:cached_annotation/cached_annotation.dart';
import 'package:test/test.dart';

import '../utils/test_storage.dart';
import '../utils/test_storage_with_data.dart';
import '../utils/test_utils.dart';
import 'persistent_storage/cached_test_persistent_storage.dart';

void main() {
  group(
    'Persistent storage',
    () {
      late TestDataProvider dataProvider;

      setUp(() {
        dataProvider = TestDataProvider();
      });

      tearDownAll(() {
        PersistentStorageHolder.storage = TestStorage();
      });

      test(
          "stored value shouldn't throw exception even when PersistentStorageHolder returns invalid type on initialization",
          () async {
        PersistentStorageHolder.storage = TestStorageWithData(
          {
            '_persistentCachedValueCached': {
              '': 'invalidType',
            },
            '_anotherPersistentCachedValueCached': {
              '': 1,
            },
            '_persistentCachedListCached': {
              '': [0, 1, 2],
            },
          },
        );

        final cachedClass = PersistentCached(dataProvider);
        final result = await cachedClass.persistentCachedValue();

        expect(result.runtimeType, equals(int));
      });

      test('works correctly when PersistentStorageHolder returns map with null value', () async {
        PersistentStorageHolder.storage = TestStorageWithData(
          {
            '_persistentCachedValueCached': {
              '': null,
            },
            '_anotherPersistentCachedValueCached': {
              '': 1,
            },
            '_persistentCachedListCached': {
              '': [0, 1, 2],
            },
          },
        );

        final cachedClass = PersistentCached(dataProvider);
        final result = await cachedClass.persistentCachedValue();

        expect(result.runtimeType, equals(int));
      });

      test('works correctly when PersistentStorageHolder returns correct cached value', () async {
        const testValue = 1;
        PersistentStorageHolder.storage = TestStorageWithData(
          {
            '_persistentCachedValueCached': {
              '': testValue,
            },
            '_anotherPersistentCachedValueCached': {
              '': 0,
            },
            '_persistentCachedListCached': {
              '': <int>[],
            },
          },
        );

        final cachedClass = PersistentCached(dataProvider);
        await cachedClass.anotherPersistentCachedValue();
        final result = cachedClass.peekCachedValue();

        expect(result, equals(testValue));
      });

      test('works correctly when PersistentStorageHolder returns correct cached list value', () async {
        const testValue = [1, 2, 3, 4, 5];
        PersistentStorageHolder.storage = TestStorageWithData(
          {
            '_persistentCachedValueCached': {
              '': 0,
            },
            '_anotherPersistentCachedValueCached': {
              '': 0,
            },
            '_persistentCachedListCached': {
              '': testValue,
            },
          },
        );

        final cachedClass = PersistentCached(dataProvider);
        await cachedClass.anotherPersistentCachedValue();
        final result = cachedClass.persistentCachedValue();

        expect(result, equals(result));
      });
    },
  );
}
