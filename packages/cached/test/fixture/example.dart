import 'package:cached_annotation/cached_annotation.dart';

@WithCache(useStaticCache: true)
abstract class Example {
  @Cached(syncWrite: true, ttl: 30, limit: 10)
  Future<int> call(
    String arg1, {
    @IgnoreCache(useCacheOnError: true) bool? ignoreCache,
  }) {
    return Future.value(5);
  }
}
