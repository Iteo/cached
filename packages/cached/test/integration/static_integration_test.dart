import 'package:async/async.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';
import 'static/cached_test_static.dart';

void main() {
  group("Static cache", () {
    late TestDataProvider _dataProvider;

    setUp(() {
      _dataProvider = TestDataProvider();
      StaticCached(_dataProvider).clearCache();
    });

    test("cache should be static", () {
      final firstCachedClass = StaticCached(_dataProvider);
      final secondsCachedClass = StaticCached(_dataProvider);

      final cachedValue = firstCachedClass.cachedValue();
      final cachedValueFromAnotherInstance = secondsCachedClass.cachedValue();

      expect(cachedValue, equals(cachedValueFromAnotherInstance));
    });

    test("stream should emit between instances", () async {
      final firstCachedClass = StaticCached(_dataProvider);
      final secondsCachedClass = StaticCached(_dataProvider);

      final queue = StreamQueue(secondsCachedClass.cachedValueCacheStream());
      final next = Future.microtask(() => queue.next);
      await Future.delayed(Duration.zero);

      final cachedValue = firstCachedClass.cachedValue();

      expect(cachedValue, equals(await next));
    });

    test('peek cache should be static', () {
      final firstCachedClass = StaticCached(_dataProvider);
      final secondsCachedClass = StaticCached(_dataProvider);

      final cachedValue = firstCachedClass.cachedValueCachePeek();
      final cachedValueFromAnotherInstance =
          secondsCachedClass.cachedValueCachePeek();

      expect(cachedValue, equals(cachedValueFromAnotherInstance));
    });

    test(
        'deletes cache method should clear cache if function returns with value',
        () {
      final cachedClass = StaticCached(_dataProvider);
      final cachedValue = cachedClass.cachedValue();
      cachedClass.deleteCachedValue();
      final secondCachedValue = cachedClass.cachedValue();

      expect(cachedValue != secondCachedValue, true);
    });

    test(
        'deletes cache method should not clear cache if function returns with error',
        () {
      final cachedClass = StaticCached(_dataProvider);
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
