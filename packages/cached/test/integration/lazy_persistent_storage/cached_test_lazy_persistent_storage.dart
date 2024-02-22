import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_lazy_persistent_storage.cached.dart';

@withCache
abstract class LazyPersistentCached implements _$LazyPersistentCached {
  factory LazyPersistentCached(TestDataProvider dataProvider) = _LazyPersistentCached;

  @Cached(lazyPersistentStorage: true)
  Future<int> lazyPersistentCachedValue() async => dataProvider.fetchRandomValue();

  @Cached(lazyPersistentStorage: true)
  Future<int> anotherLazyPersistentCachedValue() async => dataProvider.fetchRandomValue();

  @Cached(lazyPersistentStorage: true)
  Future<List<int>> lazyPersistentCachedList() async => List.filled(5, dataProvider.getRandomValue());
}
