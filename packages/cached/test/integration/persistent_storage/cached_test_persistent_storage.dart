import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_persistent_storage.cached.dart';

@withCache
abstract mixin class PersistentCachedStorage
    implements _$PersistentCachedStorage {
  factory PersistentCachedStorage(TestDataProvider dataProvider) =
      _PersistentCachedStorage;

  @persistentCached
  Future<int> persistentCachedValue() => dataProvider.fetchRandomValue();

  @persistentCached
  Future<int> anotherPersistentCachedValue() => dataProvider.fetchRandomValue();

  @persistentCached
  Future<List<int>> persistentCachedList() async =>
      List.filled(5, dataProvider.getRandomValue());

  @CachePeek('persistentCachedValue')
  int? peekCachedValue();
}
