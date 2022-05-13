import 'package:cached_annotation/cached_annotation.dart';

part 'example.cached.dart';

@WithCache(useStaticCache: true)
class Example with _$Example {
  const factory Example(int a) = _Example;

  @Cached(syncWrite: true)
  Future<int> call(
    String arg1, {
    @IgnoreCache(useCacheOnError: true) bool? ignoreCache,
  }) async {
    return Future.value(5);
  }
}
