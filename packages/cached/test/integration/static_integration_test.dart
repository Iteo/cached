import 'package:async/async.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';
import 'static/cached_test_static.dart';

void main() {
  group('Static cache', () {
    late TestDataProvider dataProvider;

    setUp(() {
      dataProvider = TestDataProvider();
      StaticCached(dataProvider).clearCache();
    });

    test('cache should be static', () {
      final firstCachedClass = StaticCached(dataProvider);
      final secondsCachedClass = StaticCached(dataProvider);

      final cachedValue = firstCachedClass.cachedValue();
      final cachedValueFromAnotherInstance = secondsCachedClass.cachedValue();

      expect(cachedValue, equals(cachedValueFromAnotherInstance));
    });

    test('stream should emit between instances', () async {
      final firstCachedClass = StaticCached(dataProvider);
      final secondsCachedClass = StaticCached(dataProvider);

      final queue = StreamQueue(secondsCachedClass.cachedValueCacheStream());
      final next = Future.microtask(() => queue.next);
      await Future<void>.delayed(Duration.zero);

      final cachedValue = firstCachedClass.cachedValue();

      expect(cachedValue, equals(await next));
    });

    test('peek cache should be static', () {
      final firstCachedClass = StaticCached(dataProvider);
      final secondsCachedClass = StaticCached(dataProvider);

      final cachedValue = firstCachedClass.cachedValueCachePeek();
      final cachedValueFromAnotherInstance =
          secondsCachedClass.cachedValueCachePeek();

      expect(cachedValue, equals(cachedValueFromAnotherInstance));
    });

    test('cache should be static', () {
      final firstCachedClass = StaticCached(dataProvider);
      final secondsCachedClass = StaticCached(dataProvider);

      final cachedValue = firstCachedClass.cachedValueGetter;
      final cachedValueFromAnotherInstance =
          secondsCachedClass.cachedValueGetter;

      expect(cachedValue, equals(cachedValueFromAnotherInstance));
    });

    test('stream should emit between instances', () async {
      final firstCachedClass = StaticCached(dataProvider);
      final secondsCachedClass = StaticCached(dataProvider);

      final queue =
          StreamQueue(secondsCachedClass.cachedValueGetterCacheStream());
      final next = Future.microtask(() => queue.next);
      await Future<void>.delayed(Duration.zero);

      final cachedValue = firstCachedClass.cachedValueGetter;

      expect(cachedValue, equals(await next));
    });

    test('peek cache should be static', () {
      final firstCachedClass = StaticCached(dataProvider);
      final secondsCachedClass = StaticCached(dataProvider);

      firstCachedClass.cachedValueGetter;

      final cachedValue = firstCachedClass.cachedValueGetterCachePeek();
      final cachedValueFromAnotherInstance =
          secondsCachedClass.cachedValueGetterCachePeek();

      expect(cachedValue, equals(cachedValueFromAnotherInstance));
    });

    test(
        'deletes cache method should clear cache if function returns with value',
        () {
      final cachedClass = StaticCached(dataProvider);
      final cachedValue = cachedClass.cachedValue();
      cachedClass.deleteCachedValue();
      final secondCachedValue = cachedClass.cachedValue();

      expect(cachedValue != secondCachedValue, true);
    });

    test(
        'deletes cache method should not clear cache if function returns with error',
        () {
      final cachedClass = StaticCached(dataProvider);
      final cachedValue = cachedClass.cachedValue();
      try {
        cachedClass.deleteCachedValueFail();
      } catch (e) {
        //
      }

      final secondCachedValue = cachedClass.cachedValue();

      expect(cachedValue != secondCachedValue, false);
    });
  });
}
