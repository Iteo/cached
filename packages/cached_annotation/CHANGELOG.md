## 1.7.1
* Bump min sdk version to 3.6.0

## 1.7.0
* Fix not working peristent storage with the getters
* Add `@DirectPersistentCached()` annotation - avoid store cached data in generated classes by cached, data will be stored only in external storage
* Add `@LazyPersistentCached()` annotation - initialize cache from external storage only after the first method call
* Mark `@Cached(persistentStorage: )` parameter as @Deprecated
* Update documentation

## 1.6.0
* Add `@Cached(persistentStorage: )` parameter, which allows you to turn on cache persisting with usage of external storage.

## 1.5.0 
* Add `@Cached(where: )` parameter - function triggered before caching the value for conditional caching.

## 1.4.0
* Add `@DeletesCache()` annotation
* Make parameters anonymous in `@CachePeek()` and `@CacheKey()` annotations
* Add support for getters for `@Cached()` annotation

## 1.3.0
* Add `@PeakCache()` annotation
* Fix generating `@StreamedCache()` with ignored parameters

## 1.2.0
* Add `@StreamedCache()` annotation

## 1.1.0
* Add `@IgnoreCache()` annotation
* Add `@CacheKey()` annotation

## 1.0.0
* Initial version of cached_annotation library
