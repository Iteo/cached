import 'package:meta/meta_meta.dart';

typedef CacheKeyGeneratorFunc = String Function(dynamic);

/// {@template cached.cache_key}
/// ### CacheKey
///
/// Annotation for `Cached` package.
///
/// Annotation that must be above a field in a method and must contain constant
/// function that will return cache key for provided field value
///
/// ### Example
///
/// Use @CacheKey annotation
///
/// ```dart
/// @cached
/// Future<int> getInt(
///   @CacheKey(cacheKeyGenerator: exampleCacheFunction) int test) async {
///   await Future.delayed(Duration(milliseconds: 20));
///   return test;
/// }
///
/// String exampleCacheFunction(dynamic value) {
///   return value.toString();
/// }
/// ```
/// {@endtemplate}
@Target({TargetKind.parameter})
class CacheKey {
  const CacheKey({required this.cacheKeyGenerator});

  final CacheKeyGeneratorFunc cacheKeyGenerator;
}

/// const instance of [CacheKey] that uses [iterableCacheKeyGenerator]
const iterableCacheKey = CacheKey(cacheKeyGenerator: iterableCacheKeyGenerator);

/// Calculates good hashcode for list of values
String iterableCacheKeyGenerator(dynamic l) {
  if (l == null || l is! Iterable) {
    return l.hashCode.toString();
  }

  return Object.hashAll(l).toString();
}
