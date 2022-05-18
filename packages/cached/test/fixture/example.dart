import 'package:cached_annotation/cached_annotation.dart';

@WithCache(useStaticCache: true)
class Example with _$Example {
  factory Example(int a) = _Example;

  @Cached(syncWrite: true, ttl: 30, limit: 10)
  Future<int> call(
    String arg1, {
    @IgnoreCache(useCacheOnError: true) bool ignoreCache = true,
  }) {
    return Future.value(5);
  }
}
