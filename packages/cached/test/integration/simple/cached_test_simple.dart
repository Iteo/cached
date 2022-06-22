import 'dart:async';

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
  int cachedValueWithCustomKey(
      @CacheKey(cacheKeyGenerator: _cachedKeyGenerator) String value) {
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
  int cachedTimestampWithoutIgnore({bool smth = false}) {
    return dataProvider.getCurrentTimestamp();
  }

  @cached
  int cachedTimestampWithIgnore({@ignore bool smth = false}) {
    return dataProvider.getCurrentTimestamp();
  }

  @StreamedCache(methodName: "cachedValue", emitLastValue: false)
  Stream<int> streamOfCachedValue();

  @StreamedCache(methodName: "cachedTimestamp", emitLastValue: true)
  Stream<int> streamOfCachedTimestampLastValue();

  @clearCached
  void clearCachedValue();

  @ClearCached("cachedTimestamp")
  void clearTimestamp();

  @clearAllCached
  void clearAll();
}

String _cachedKeyGenerator(dynamic value) => value.toString();
