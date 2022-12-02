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
