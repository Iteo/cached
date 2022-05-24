import 'package:cached_annotation/cached_annotation.dart';
import 'package:test/test.dart';
import '../utils/test_utils.dart';
import 'simple/cached_test_simple.dart';

void main() {
  group('SimpleCache', () {
    late TestDataProvider _dataProvider;

    setUp(() {
      _dataProvider = TestDataProvider();
    });

    test('cached value should be the same on the second method call', () {
      final cachedClass = SimpleCached(_dataProvider);
      final cachedValue = cachedClass.cachedValue();
      final secondCachedValue = cachedClass.cachedValue();

      expect(cachedValue, equals(secondCachedValue));
    });

    test('clear cache method should clear cache', () {
      final cachedClass = SimpleCached(_dataProvider);
      final cachedValue = cachedClass.cachedValue();
      cachedClass.clearCachedValue();
      final secondCachedValue = cachedClass.cachedValue();

      expect(cachedValue != secondCachedValue, true);
    });

    test('setting ignoreCache to true should ignore cached value and return new one', () async {
      final cachedClass = SimpleCached(_dataProvider);
      final cachedValue = cachedClass.cachedTimestamp();
      await Future.delayed(const Duration(milliseconds: 10));
      final secondCachedValue = cachedClass.cachedTimestamp(refresh: true);

      expect(cachedValue != secondCachedValue, true);
    });

    test('calling other clear cache method, should not clear cache', () {
      final cachedClass = SimpleCached(_dataProvider);
      final cachedValue = cachedClass.cachedTimestamp();
      cachedClass.clearCachedValue();
      final secondCachedValue = cachedClass.cachedTimestamp();

      expect(cachedValue == secondCachedValue, true);
    });

    test('clearing all cache method should clear cache', () async {
      final cachedClass = SimpleCached(_dataProvider);
      final cachedValue = cachedClass.cachedValue();
      final cachedTimestamp = cachedClass.cachedTimestamp();
      await Future.delayed(const Duration(milliseconds: 10));

      cachedClass.clearAll();
      final secondCachedValue = cachedClass.cachedValue();
      final secondCachedTimestamp = cachedClass.cachedTimestamp();

      expect(cachedValue != secondCachedValue, true);
      expect(cachedTimestamp != secondCachedTimestamp, true);
    });
  });
}
