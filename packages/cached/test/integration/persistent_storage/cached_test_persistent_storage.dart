import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_persistent_storage.cached.dart';

@withCache
abstract class PersistentCached implements _$PersistentCached {
  factory PersistentCached(TestDataProvider dataProvider) = _PersistentCached;

  @Cached(persistentStorage: true)
  Future<int> persistentCachedValue() => dataProvider.fetchRandomValue();

  @Cached(persistentStorage: true)
  Future<int> anotherPersistentCachedValue() => dataProvider.fetchRandomValue();

  @Cached(persistentStorage: true)
  Future<List<int>> persistentCachedList() async => List.filled(5, dataProvider.getRandomValue());

  @CachePeek('persistentCachedValue')
  int? peekCachedValue();
}
