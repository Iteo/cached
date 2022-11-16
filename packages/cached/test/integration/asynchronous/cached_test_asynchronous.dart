import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_asynchronous.cached.dart';

const int ttlDurationSeconds = 1;

@withCache
abstract class AsynchronousCached implements _$AsynchronousCached {
  int _counter = 0;

  factory AsynchronousCached(
    TestDataProvider dataProvider,
  ) = _AsynchronousCached;

  @Cached(syncWrite: true)
  Future<int> syncCachedValue({@ignoreCache bool refresh = false}) {
    return dataProvider.fetchRandomValue();
  }

  @StreamedCache(methodName: "syncCachedValue", emitLastValue: false)
  Stream<int> syncCachedValueStream();

  @Cached(syncWrite: true)
  Future<int> syncCachedValueWithoutIgnore({bool smth = false}) {
    return dataProvider.fetchRandomValue();
  }

  @Cached(syncWrite: true)
  Future<int> syncCachedValueWithIgnore({@ignore bool smth = false}) {
    return dataProvider.fetchRandomValue();
  }

  @Cached(ttl: ttlDurationSeconds, syncWrite: true)
  Future<int> syncCachedValueWithTTl() async {
    _counter++;
    await Future.delayed(const Duration(milliseconds: 100));
    return dataProvider.fetchRandomValue();
  }

  @Cached(syncWrite: false)
  Future<int> asyncCachedValue({@ignoreCache bool refresh = false}) {
    return dataProvider.fetchRandomValue();
  }

  @Cached(ttl: ttlDurationSeconds, syncWrite: false)
  Future<int> asyncCachedValueWithTTl() async {
    _counter++;
    await Future.delayed(const Duration(milliseconds: 100));
    return dataProvider.fetchRandomValue();
  }

  @StreamedCache(methodName: "asyncCachedValue", emitLastValue: false)
  Stream<int> asyncCacheStream();

  @CachePeek(methodName: "asyncCachedValue")
  int? asyncCachePeek();

  @ClearCached("asyncCachedValue")
  Future<void> clearAsyncCachedValue();

  @ClearCached("asyncCachedValueWithTTl")
  void clearAsyncTTLCachedValue();

  @ClearCached("syncCachedValue")
  void clearCachedValue();

  @ClearCached("syncCachedValueWithTTl")
  void clearCachedValueWithTTl();

  @clearAllCached
  void clearAll();

  void resetCounter() => _counter = 0;

  int counter() => _counter;

  @DeletesCache(['asyncCachedValue'])
  Future<void> deleteAsyncCachedValue() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @DeletesCache(['asyncCachedValue'])
  Future<void> deleteAsyncCachedValueFail() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception();
  }

  @DeletesCache(['asyncCachedValueWithTTl'])
  Future<void> deleteAsyncTTLCachedValue() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @DeletesCache(['asyncCachedValueWithTTl'])
  Future<void> deleteAsyncTTLCachedValueFail() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception();
  }

  @DeletesCache(['syncCachedValue'])
  Future<void> deleteCachedValue() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @DeletesCache(['syncCachedValue'])
  Future<void> deleteCachedValueFail() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception();
  }

  @DeletesCache(['syncCachedValueWithTTl'])
  Future<void> deleteTTLCachedValue() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @DeletesCache(['syncCachedValueWithTTl'])
  Future<void> deleteTTLCachedValueFail() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception();
  }
}
