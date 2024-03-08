## 1.7.0
* Fix not working peristent storage with the getters
* Add `@DirectPersistentCached()` annotation - avoid store 
* Add `@LazyPersistentCached()` annotation - initialize cache from external storage only after the first method call
* Mark `@Cached(persistentStorage: )` as @Deprecated
* Update documentation

## 1.6.4
* Fix the `PersistentStorageHolder` which wasn't checking if stored value type matches the method return type (see [#105](https://github.com/Iteo/cached/issues/105))

## 1.6.3
* Update SDK version `>=2.17.0 <4.0.0`

## 1.6.2
* Update analyzer

## 1.6.1
* Fix `@Cached(limit: )` parameter - LRU cache algorithm was not working correctly.

## 1.6.0
* Add `@Cached(persistentStorage: )` parameter, which allows you to turn on cache persisting with usage of external storage.

## 1.5.1
* Fix documentation links
* Fix intendation in documentation
  
## 1.5.0 
* Add `@Cached(where: )` parameter - function triggered before caching the value for conditional caching.
* Documentation update with examples for `where:` parameter

## 1.4.0
* Add `@DeletesCache()` annotation
* Make parameters anonymous in `@CachePeek()` and `@CacheKey()` annotations
* Add support for getters for `@Cached()` annotation

## 1.3.1
* Allow `@ClearCached()` and `@ClearAllCached()` methods to return `Future<void>`

## 1.3.0
* Add `@PeakCache()` annotation
* Fix generating `@StreamedCache()` with ignored parameters

## 1.2.2
* Fix analysis

## 1.2.1
* Fix decumentation redirects

## 1.2.0
* Add `@StreamedCache()` annotation

## 1.1.0
* Add `@IgnoreCache()` annotation
* Add `@CacheKey()` annotation

## 1.0.4
* Change analyzer version to ">=3.0.0 <5.0.0"

## 1.0.3
* Downgrade meta package to 1.7.0

## 1.0.2
* Fix README.md

## 1.0.1
* Fix analyzer warnings 

## 1.0.0
* Initial version of cached library
