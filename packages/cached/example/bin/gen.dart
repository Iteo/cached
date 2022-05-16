import 'package:cached_annotation/cached_annotation.dart';

part 'gen.cached.dart';

@WithCache(useStaticCache: true)
abstract class Gen implements _$Gen {
  const factory Gen(int a) = _Gen;

  @Cached(syncWrite: true, ttl: 30, limit: 10)
  Future<int> call(
    String arg1, {
    @IgnoreCache(useCacheOnError: true) bool ignoreCache = true,
  }) {
    return Future.value(5);
  }
}
