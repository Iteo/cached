import 'package:test/test.dart';

import '../utils/test_utils.dart';
import 'conditional/cached_test_conditional.dart';

void main() {
  group(
    'Conditional cache',
    () {
      late TestDataProvider dataProvider;

      setUp(() {
        dataProvider = TestDataProvider();
      });

      test(
          'cached value should be the same on the second method call (condition: always cached)',
          () {
        final cachedClass = ConditionalCached(dataProvider);
        final cachedValue = cachedClass.alwaysCachedValue();
        final secondCachedValue = cachedClass.alwaysCachedValue();

        expect(cachedValue, equals(secondCachedValue));
      });

      test(
          'cached value should be different on the second method call (condition: never cached)',
          () {
        final cachedClass = ConditionalCached(dataProvider);
        final cachedValue = cachedClass.neverCachedValue();
        final secondCachedValue = cachedClass.neverCachedValue();

        expect(cachedValue, isNot(equals(secondCachedValue)));
      });

      test(
          'cached value should be the same on the second method call (condition: always cached) (async version)',
          () async {
        final cachedClass = ConditionalCached(dataProvider);
        final cachedValue =
            await cachedClass.alwaysCachedValueWithFutureCondition();
        final secondCachedValue =
            await cachedClass.alwaysCachedValueWithFutureCondition();

        expect(cachedValue, equals(secondCachedValue));
      });

      test(
          'cached value should be different on the second method call (condition: never cached) (async version)',
          () {
        final cachedClass = ConditionalCached(dataProvider);
        final cachedValue = cachedClass.neverCachedValueWithFutureCondition();
        final secondCachedValue =
            cachedClass.neverCachedValueWithFutureCondition();

        expect(cachedValue, isNot(equals(secondCachedValue)));
      });

      test(
          'setting ignoreCache to true should always return new value (condition: always cached)',
          () async {
        final cachedClass = ConditionalCached(dataProvider);
        final cachedValue = cachedClass.alwaysCachedTimestampWithIgnore();
        await Future.delayed(const Duration(milliseconds: 10));
        final secondCachedValue = cachedClass.cachedTimestamp(refresh: true);

        expect(cachedValue, isNot(equals(secondCachedValue)));
      });

      test(
          'setting ignoreCache to true should always return new value (condition: never cached)',
          () async {
        final cachedClass = ConditionalCached(dataProvider);
        final cachedValue = cachedClass.neverCachedTimestampWithIgnore();
        await Future.delayed(const Duration(milliseconds: 10));
        final secondCachedValue = cachedClass.cachedTimestamp(refresh: true);

        expect(cachedValue, isNot(equals(secondCachedValue)));
      });
    },
  );
}
