import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_lazy_persistent_storage.cached.dart';

@withCache
abstract class LazyPersistentCachedStorage
    implements _$LazyPersistentCachedStorage {
  factory LazyPersistentCachedStorage(TestDataProvider dataProvider) =
      _LazyPersistentCachedStorage;

  @lazyPersistentCached
  Future<int> lazyPersistentCachedValue() async =>
      dataProvider.fetchRandomValue();

  @lazyPersistentCached
  Future<int> anotherLazyPersistentCachedValue() async =>
      dataProvider.fetchRandomValue();

  @lazyPersistentCached
  Future<List<int>> lazyPersistentCachedList() async =>
      List.filled(5, dataProvider.getRandomValue());
}
