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
    @CacheKey(_cachedKeyGenerator) String value,
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

  @StreamedCache(methodName: 'cachedValue')
  Stream<int> streamOfCachedValue();

  @StreamedCache(methodName: 'cachedTimestamp', emitLastValue: true)
  Stream<int> streamOfCachedTimestampLastValue();

  @StreamedCache(methodName: 'nullableCachedValue', emitLastValue: true)
  Stream<int?> nullableCacheValueStream();

  @CachePeek('cachedValue')
  int? cachePeekValue();

  @CachePeek('cachedTimestamp')
  int? timestampCachePeekValue();

  @CachePeek('cachedValueWithCustomKey')
  int? peekCachedValueWithCustomKey(
    @CacheKey(_cachedKeyGenerator) String value,
  );

  @clearCached
  void clearCachedValue();

  @ClearCached('cachedTimestamp')
  Future<void> clearTimestamp();

  @clearAllCached
  void clearAll();

  @cached
  int get cachedValueGetter {
    return dataProvider.getRandomValue();
  }

  @cached
  int? get nullableCachedValueGetter {
    return null;
  }

  @StreamedCache(
    methodName: 'nullableCachedValueGetter',
    emitLastValue: true,
  )
  Stream<int?> nullableCacheGetterValueStream();

  @StreamedCache(methodName: 'cachedValueGetter')
  Stream<int> streamOfCachedGetterValue();

  @CachePeek('nullableCachedValueGetter')
  int? nullableCacheGetterPeekValue();

  @CachePeek('cachedValueGetter')
  int? cacheGetterPeekValue();

  @clearCached
  void clearCachedValueGetter();

  @DeletesCache(['cachedValue'])
  void deleteCachedValue() {}

  @DeletesCache(['cachedValue'])
  void deleteCachedValueFail() {
    throw Exception();
  }

  @Cached(
    syncWrite: true,
    limit: 5,
  )
  int getCachedValueWithLimitFive(int parameter) {
    return dataProvider.getRandomValue();
  }

  @CachePeek('getCachedValueWithLimitFive')
  int? peekCachedValueWithLimitFive(int parameter);

  @Cached(
    syncWrite: true,
    limit: 1,
  )
  int getCachedValueWithLimitOne(int parameter) {
    return dataProvider.getRandomValue();
  }

  @CachePeek('getCachedValueWithLimitOne')
  int? peekCachedValueWithLimitOne(int parameter);
}

String _cachedKeyGenerator(dynamic value) => value.toString();
