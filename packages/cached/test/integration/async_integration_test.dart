import 'package:async/async.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';
import 'asynchronous/cached_test_asynchronous.dart';

int _slightlyLessThanTTL() => ttlDurationSeconds * 1000 - 10;

void main() {
  group('AsynchronousCache with syncWrite: TRUE', () {
    late TestDataProvider _dataProvider;

    setUp(() {
      _dataProvider = TestDataProvider();
    });

    test('cached value should be the same on the second method call', () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final results = await Future.wait(
        [cachedClass.syncCachedValue(), cachedClass.syncCachedValue()],
      );

      expect(results[0], equals(results[1]));
    });

    test('clear cache method should clear cache', () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.syncCachedValue();
      cachedClass.clearCachedValue();
      final secondCachedValue = await cachedClass.syncCachedValue();

      expect(cachedValue != secondCachedValue, true);
    });

    test('should ignore the argument as a cache key', () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue =
          await cachedClass.syncCachedValueWithIgnore(smth: true);
      final secondCachedValue = await cachedClass.syncCachedValueWithIgnore();

      expect(cachedValue == secondCachedValue, true);
    });

    test(
        'setting ignoreCache to true should ignore cached value and return new one',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.syncCachedValue();
      final secondCachedValue =
          await cachedClass.syncCachedValue(refresh: true);

      expect(cachedValue != secondCachedValue, true);
    });

    test(
        'cached method with set TTL, should return old value when there is no timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.syncCachedValueWithTTl();
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.syncCachedValueWithTTl();

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(Duration(milliseconds: _slightlyLessThanTTL()));
      await cachedClass.syncCachedValueWithTTl();

      expect(cachedClass.counter(), 1);
    });

    test('cached method with set TTL, should return new value when TTL timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.syncCachedValueWithTTl();
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.syncCachedValueWithTTl();

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(const Duration(seconds: ttlDurationSeconds));
      await cachedClass.syncCachedValueWithTTl();

      expect(cachedClass.counter(), 2);
    });

    test('cached stream works', () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final streamValue = StreamQueue(cachedClass.asyncCacheStream());
      final next = Future.microtask(() => streamValue.next);
      await Future.delayed(Duration.zero);

      final cachedValue = await cachedClass.asyncCachedValue();

      expect(cachedValue, await next);
    });

    test('cached value should be the same on the second getter call', () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final results = await Future.wait(
        [cachedClass.syncCachedValueGetter, cachedClass.syncCachedValueGetter],
      );

      expect(results[0], equals(results[1]));
    });

    test('clear cache method should clear cache', () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.syncCachedValueGetter;
      cachedClass.clearCachedValueGetter();
      final secondCachedValue = await cachedClass.syncCachedValueGetter;

      expect(cachedValue != secondCachedValue, true);
    });

    test(
        'cached getter with set TTL, should return old value when there is no timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.syncCachedValueGetterWithTTl;
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.syncCachedValueGetterWithTTl;

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(Duration(milliseconds: _slightlyLessThanTTL()));
      await cachedClass.syncCachedValueGetterWithTTl;

      expect(cachedClass.counter(), 1);
    });

    test('cached getter with set TTL, should return new value when TTL timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.syncCachedValueGetterWithTTl;
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.syncCachedValueGetterWithTTl;

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(const Duration(seconds: ttlDurationSeconds));
      await cachedClass.syncCachedValueGetterWithTTl;

      expect(cachedClass.counter(), 2);
    });

    test('cached stream works', () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final streamValue = StreamQueue(cachedClass.asyncCacheGetterStream());
      final next = Future.microtask(() => streamValue.next);
      await Future.delayed(Duration.zero);

      final cachedValue = await cachedClass.asyncCachedValueGetter;

      expect(cachedValue, await next);
    });
  });
  group('AsynchronousCache with syncWrite: FALSE', () {
    late TestDataProvider _dataProvider;

    setUp(() {
      _dataProvider = TestDataProvider();
    });

    test(
        'two calls of the same async functions, should return different values',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final results = await Future.wait(
        [cachedClass.asyncCachedValue(), cachedClass.asyncCachedValue()],
      );

      expect(results[0], isNot(equals(results[1])));
    });

    test(
        'cached method with set TTL, should return old value when there is no timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.asyncCachedValueWithTTl();
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.asyncCachedValueWithTTl();

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(Duration(milliseconds: _slightlyLessThanTTL()));

      expect(cachedClass.counter(), 2);
    });

    test('cached method with set TTL, should return new value when TTL timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.asyncCachedValueWithTTl();
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.asyncCachedValueWithTTl();

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(const Duration(seconds: ttlDurationSeconds));
      await cachedClass.asyncCachedValueWithTTl();

      expect(cachedClass.counter(), 3);
    });

    test('peek cache value should be the same on the async cached value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.asyncCachedValue();
      final secondCachedValue = cachedClass.asyncCachePeek();

      expect(cachedValue, equals(secondCachedValue));
    });
    test('two calls of the same async getter, should return different values',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final results = await Future.wait(
        [
          cachedClass.asyncCachedValueGetter,
          cachedClass.asyncCachedValueGetter
        ],
      );

      expect(results[0], isNot(equals(results[1])));
    });

    test(
        'cached getter with set TTL, should return old value when there is no timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.asyncCachedValueGetterWithTTl;
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.asyncCachedValueGetterWithTTl;

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(Duration(milliseconds: _slightlyLessThanTTL()));

      expect(cachedClass.counter(), 2);
    });

    test('cached method with set TTL, should return new value when TTL timeout',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);

      final cachedValueFuture = cachedClass.asyncCachedValueGetterWithTTl;
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValueFuture = cachedClass.asyncCachedValueGetterWithTTl;

      await Future.wait([cachedValueFuture, secondCachedValueFuture]);
      await Future.delayed(const Duration(seconds: ttlDurationSeconds));
      await cachedClass.asyncCachedValueGetterWithTTl;

      expect(cachedClass.counter(), 3);
    });

    test('peek cache value should be the same on the async cached value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.asyncCachedValueGetter;
      final secondCachedValue = cachedClass.asyncCacheGetterPeek();

      expect(cachedValue, equals(secondCachedValue));
    });

    test(
        'deletes cache method should clear async cache if future returns value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.asyncCachedValue();
      await cachedClass.deleteAsyncCachedValue();
      final secondCachedValue = await cachedClass.asyncCachedValue();

      expect(cachedValue != secondCachedValue, true);
    });

    test(
        'deletes cache method should not clear async cache if future fails to return value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.asyncCachedValue();
      try {
        await cachedClass.deleteAsyncCachedValueFail();
      } catch (e) {
        //
      }

      final secondCachedValue = await cachedClass.asyncCachedValue();

      expect(cachedValue != secondCachedValue, false);
    });

    test('deletes cache method should clear sync cache if future returns value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.syncCachedValue();
      await cachedClass.deleteCachedValue();
      final secondCachedValue = await cachedClass.syncCachedValue();

      expect(cachedValue != secondCachedValue, true);
    });

    test(
        'deletes cache method should not clear sync cache if future fails to return value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.syncCachedValue();
      try {
        await cachedClass.deleteCachedValueFail();
      } catch (e) {
        //
      }

      final secondCachedValue = await cachedClass.syncCachedValue();

      expect(cachedValue != secondCachedValue, false);
    });

    test(
        'deletes cache method should clear async cache with ttl if future returns value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.asyncCachedValueWithTTl();
      await cachedClass.deleteAsyncTTLCachedValue();
      final secondCachedValue = await cachedClass.asyncCachedValueWithTTl();

      expect(cachedValue != secondCachedValue, true);
    });

    test(
        'deletes cache method should clear sync cache with ttl if future returns value',
        () async {
      final cachedClass = AsynchronousCached(_dataProvider);
      final cachedValue = await cachedClass.syncCachedValueWithTTl();
      await cachedClass.deleteTTLCachedValue();
      final secondCachedValue = await cachedClass.syncCachedValueWithTTl();

      expect(cachedValue != secondCachedValue, true);
    });
  });
}
