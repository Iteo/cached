import 'package:cached_annotation/cached_annotation.dart';

import '../../utils/test_utils.dart';

part 'cached_test_static.cached.dart';

@WithCache(useStaticCache: true)
abstract class StaticCached implements _$StaticCached {
  factory StaticCached(TestDataProvider dataProvider) = _StaticCached;

  @cached
  int cachedValue() {
    return dataProvider.getRandomValue();
  }

  @StreamedCache(methodName: "cachedValue")
  Stream<int> cachedValueCacheStream();

  @clearAllCached
  void clearCache();
}
