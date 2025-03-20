import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_static.cached.dart';

@WithCache(useStaticCache: true)
abstract mixin class StaticCached implements _$StaticCached {
  factory StaticCached(TestDataProvider dataProvider) = _StaticCached;

  @cached
  int cachedValue() {
    return dataProvider.getRandomValue();
  }

  @StreamedCache(methodName: 'cachedValue')
  Stream<int> cachedValueCacheStream();

  @CachePeek('cachedValue')
  int? cachedValueCachePeek();

  @clearAllCached
  void clearCache();

  @cached
  int get cachedValueGetter {
    return dataProvider.getRandomValue();
  }

  @StreamedCache(methodName: 'cachedValueGetter')
  Stream<int> cachedValueGetterCacheStream();

  @CachePeek('cachedValueGetter')
  int? cachedValueGetterCachePeek();

  @DeletesCache(['cachedValue'])
  void deleteCachedValue() {}

  @DeletesCache(['cachedValue'])
  void deleteCachedValueFail() {
    throw Exception();
  }
}
