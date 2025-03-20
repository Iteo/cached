import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_direct_persistent_storage.cached.dart';

@withCache
abstract mixin class DirectPersistentCachedStorage
    implements _$DirectPersistentCachedStorage {
  factory DirectPersistentCachedStorage(TestDataProvider dataProvider) =
      _DirectPersistentCachedStorage;

  @directPersistentCached
  Future<int> directPersistentCachedValue() async =>
      dataProvider.fetchRandomValue();

  @directPersistentCached
  Future<int> anotherDirectPersistentCachedValue() async =>
      dataProvider.fetchRandomValue();

  @directPersistentCached
  Future<List<int>> directPersistentCachedList() async =>
      List.filled(5, dataProvider.getRandomValue());
}
