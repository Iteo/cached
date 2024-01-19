import 'package:cached_annotation/cached_annotation.dart';
import 'package:test/test.dart';

import '../utils/test_storage.dart';
import '../utils/test_storage_with_data.dart';
import '../utils/test_utils.dart';
import 'persistent_storage/cached_test_persistent_storage.dart';

void main() {
  group(
    'PersistentStorage',
    () {
      late TestDataProvider dataProvider;

      setUp(() {
        dataProvider = TestDataProvider();
      });

      tearDownAll(() {
        PersistentStorageHolder.storage = TestStorage();
      });

      test("returns other data then the existing one in storage, when storage's cached value (on init) is null",
          () async {
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
        expect(result, isNot(null));
      });

      test('returns the data from itself, when its cached value (on init) is correct', () async {
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

      test('returns the data from itself, when its cached list value (on init) is correct', () async {
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
        final result = await cachedClass.persistentCachedList();

        expect(result, equals(testValue));
      });

      test(
          "returns other data then the existing one in storage, when storage's cached list value type (on init) is not the same as declared method return type",
          () async {
        const testValue = [1, 2, '3', 4, 5];
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
        final result = await cachedClass.persistentCachedList();

        expect(result.runtimeType, equals(List<int>));
        expect(result.runtimeType, isNot(equals(testValue.runtimeType)));
      });

      test(
          "returns other data then the existing one in storage, when storage's cached value type (on init) is not the same as declared method return type",
          () async {
        const invalidType = 'invalidType';
        PersistentStorageHolder.storage = TestStorageWithData(
          {
            '_persistentCachedValueCached': {
              '': invalidType,
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
        expect(result.runtimeType, isNot(equals(invalidType.runtimeType)));
      });
    },
  );
}
