import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_conditional.cached.dart';

@withCache
abstract class ConditionalCached implements _$ConditionalCached {
  factory ConditionalCached(
    TestDataProvider dataProvider,
  ) = _ConditionalCached;

  @Cached(where: _alwaysCache)
  int alwaysCachedValue() {
    return dataProvider.getRandomValue();
  }

  @Cached(where: _neverCache)
  int neverCachedValue() {
    return dataProvider.getRandomValue();
  }

  @Cached(where: _alwaysCacheFutureCondition)
  Future<int> alwaysCachedValueWithFutureCondition() {
    return dataProvider.fetchRandomValue();
  }

  @Cached(where: _neverCacheFutureCondition)
  Future<int> neverCachedValueWithFutureCondition() async {
    return dataProvider.getRandomValue();
  }

  @Cached(where: _alwaysCache)
  int cachedTimestamp({
    @ignoreCache bool refresh = false,
  }) {
    return dataProvider.getCurrentTimestamp();
  }

  @Cached(where: _alwaysCache)
  int alwaysCachedTimestampWithIgnore({@ignoreCache bool smth = true}) {
    return dataProvider.getCurrentTimestamp();
  }

  @Cached(where: _neverCache)
  int neverCachedTimestampWithIgnore({@ignoreCache bool smth = true}) {
    return dataProvider.getCurrentTimestamp();
  }

  @Cached(where: _nullable)
  int? nullableCachedValue() {
    return null;
  }

  @Cached(where: _futureNullable)
  Future<int?> anotherNullableCachedValue() {
    return Future.value();
  }

  @Cached(where: _alwaysCache)
  int get alwaysCachedValueGetter {
    return dataProvider.getRandomValue();
  }

  @Cached(where: _neverCache)
  int get neverCachedValueGetter {
    return dataProvider.getRandomValue();
  }

  @Cached(where: _nullable)
  int? get nullableCachedValueGetter {
    return null;
  }

  @Cached(where: _futureNullable)
  Future<int?> get anotherNullableCachedValueGetter {
    return Future.value();
  }
}

bool _alwaysCache(int candidate) {
  return true;
}

bool _neverCache(int candidate) {
  return false;
}

Future<bool> _alwaysCacheFutureCondition(int candidate) async {
  await Future.delayed(const Duration(milliseconds: 100));
  return Future.value(true);
}

Future<bool> _neverCacheFutureCondition(int candidate) async {
  await Future.delayed(const Duration(milliseconds: 100));
  return Future.value(false);
}

bool _nullable(int? candidate) {
  return candidate == null;
}

Future<bool> _futureNullable(int? candidate) async {
  return candidate == null;
}
