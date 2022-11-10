import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_simple.cached.dart';

@withCache
abstract class SimpleCached implements _$SimpleCached {
  factory SimpleCached(
    TestDataProvider dataProvider,
  ) = _SimpleCached;

  @cached
  int cachedValue() {
    return dataProvider.getRandomValue();
  }

  @cached
  int anotherCachedValue() {
    return dataProvider.getRandomValue();
  }

  @cached
  int cachedValueWithCustomKey(
    @CacheKey(cacheKeyGenerator: _cachedKeyGenerator) String value,
  ) {
    return dataProvider.getRandomValue();
  }

  @cached
  int cachedWithIterableCacheKey(@iterableCacheKey List<String> values) {
    return dataProvider.getRandomValue();
  }

  @cached
  int cachedWithNullableList(@iterableCacheKey List<String>? values) {
    return dataProvider.getRandomValue();
  }

  @cached
  int cachedTimestamp({
    @ignoreCache bool refresh = false,
  }) {
    return dataProvider.getCurrentTimestamp();
  }

  @cached
  int anotherCachedTimestamp({
    @ignoreCache bool refresh = false,
  }) {
    return dataProvider.getCurrentTimestamp();
  }

  @cached
  int cachedTimestampWithoutIgnore({bool smth = false}) {
    return dataProvider.getCurrentTimestamp();
  }

  @cached
  int cachedTimestampWithIgnore({@ignore bool smth = false}) {
    return dataProvider.getCurrentTimestamp();
  }

  @cached
  int? nullableCachedValue() {
    return null;
  }

  @StreamedCache(methodName: "cachedValue")
  Stream<int> streamOfCachedValue();

  @StreamedCache(methodName: "cachedTimestamp", emitLastValue: true)
  Stream<int> streamOfCachedTimestampLastValue();

  @StreamedCache(methodName: "nullableCachedValue", emitLastValue: true)
  Stream<int?> nullableCacheValueStream();

  @CachePeek(methodName: "cachedValue")
  int? cachePeekValue();

  @CachePeek(methodName: "cachedTimestamp")
  int? timestampCachePeekValue();

  @CachePeek(methodName: "cachedValueWithCustomKey")
  int? peekCachedValueWithCustomKey(
    @CacheKey(cacheKeyGenerator: _cachedKeyGenerator) String value,
  );

  @clearCached
  void clearCachedValue();

  @ClearCached("cachedTimestamp")
  Future<void> clearTimestamp();

  @clearAllCached
  void clearAll();

  @DeletesCache(['cachedValue'])
  void deleteCachedValue() {}

  @DeletesCache(['cachedValue'])
  void deleteCachedValueFail() {
    throw Exception();
  }
}

String _cachedKeyGenerator(dynamic value) => value.toString();
