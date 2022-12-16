<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
<div align="center">
<br /><br />
<img width="128" src="https://github.com/Iteo/cached/raw/master/packages/cached/cached_sygnet.png">
<br /><br />

[![Test status](https://github.com/Iteo/cached/workflows/Build/badge.svg)](https://github.com/Iteo/cached/actions/workflows/build.yml)
&nbsp;
[![stars](https://img.shields.io/github/stars/Iteo/cached.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/Iteo/cached)
&nbsp;
[![pub package](https://img.shields.io/pub/v/cached.svg)](https://pub.dartlang.org/packages/cached) &nbsp;
[![GitHub license](https://img.shields.io/badge/licence-MIT-green)](https://github.com/Iteo/cached/blob/master/packages/cached/LICENSE)
&nbsp;
[![style:linteo](https://img.shields.io/badge/style-linteo-orange)](https://pub.dev/packages/linteo) &nbsp;
</div>

---

<h1>Cached</h1>

Simple Dart package with build-in code generation. It simplifies and speedup creation of cache mechanism for dart
classes.

## Least Recently Used (LRU) cache algorithm

It is a finite key-value map using
the [Least Recently Used (LRU)](https://en.wikipedia.org/wiki/Cache_algorithms#Least_Recently_Used) algorithm, where the
most recently-used items are "kept alive" while older, less-recently used items are evicted to make room for newer
items.

Useful when you want to limit use of memory to only hold commonly-used things or cache some API calls.

## Contents

<!-- pub.dev accepts anchors only with lowercase -->

- [Least Recently Used (LRU) cache algorithm](#least-recently-used-lru-cache-algorithm)
- [Contents](#contents)
- [Motivation](#motivation)
- [Setup](#setup)
  - [Install package](#install-package)
  - [Run the generator](#run-the-generator)
- [Basics](#basics)
  - [WithCache](#withcache)
  - [Cached](#cached)
    - [Example](#example)
    - [Example with getter](#example-with-getter)
    - [where](#where)
      - [sync example](#sync-example)
      - [async example](#async-example)
  - [IgnoreCache](#ignorecache)
  - [Ignore](#ignore)
  - [CacheKey](#cachekey)
  - [ClearCached](#clearcached)
  - [ClearAllCached](#clearallcached)
  - [StreamedCache](#streamedcache)
  - [CachePeek](#cachepeek)
  - [DeletesCache](#deletescache)
- [Persistent storage](#persistent-storage)
- [Contribution](#contribution)
  - [feature request](#feature-request)
  - [Fix](#fix)
- [Contributors](#contributors)

## Motivation

There is quite often situation, that you have to cache something in memory for later usage. Common case is cache some
API calls and theirs responses.
Usually, it is done in some data layer, probably in - let say - `RemoteRepository`

Oftentimes, the repository code might look like this:

```dart
class RemoteRepository implements Repository {
  final SomeApiDataSource _dataSource;
  final SomeResponseType? cachedResponse;

  const RemoteRepository(this._dataSource);

  @override
  Future<SomeResponseType> getSthData() async {
    if (cachedResponse != null) {
      return cachedResponse;
    }

    cachedResponse = await _dataSource.getData();
    return cachedResponse;
  }
}
```

So, instead of doing it manually we can use library and write our `RemoteRepository` in that way:

```dart
@WithCache()
abstract class RemoteRepository implements Repository, _$RemoteRepository {
  factory RemoteRepository({required SomeApiDataSource dataSource,}) = _RemoteRepository;

  @Cached()
  Future<SomeResponseType> getSthData() {
    return dataSource.getData();
  }
}
```

## Setup

### Install package

Run command:

```shell
flutter pub add --dev cached
flutter pub add cached_annotation
```

Or manually add the dependency in the `pubspec.yaml`

```yaml
dependencies:
  cached_annotation:

dev_dependencies:
  cached:
```

That's it! Now, you can write your own cached class :tada:

### Run the generator

To run the code generator, execute the following command:

```dart
dart run build_runner build
```

For Flutter projects, you can run:

```dart
flutter pub run build_runner build
```

Note that like most code-generators, [Cached] will need you to both import the annotation ([cached_annotation])
and use the `part` keyword on the top of your files.

As such, a file that wants to use [Cached] will start with:

```dart
import 'package:cached_annotation/cached_annotation.dart';

part 'some_file.cached.dart';
```

## Basics

### WithCache

Annotation for `Cached` package.

Annotating a class with `@WithCache` will flag it as a needing to be processed by `Cached` code generator.
\
It can take one additional boolean parameter `useStaticCache`. If this parameter is set to true, generator will generate
cached class with static cache. It means each instance of this class will have access to the same cache. Default value
is set to `false`

```dart
@WithCache(useStaticCache: true)
abstract class Gen implements _$Gen {
  factory Gen() = _Gen;

  ...
}
```

### Cached

Method/Getter decorator that flag it as needing to be processed by `Cached` code generator.

There are 4 possible additional parameters:

- `ttl` - time to live. In seconds. Set how long cache will be alive. Default value is set to null, means infinitive
  ttl.
- `syncWrite` - Affects only async methods ( those one that returns Future ) If set to `true` first method call will be
  cached, and if following ( the same ) call will occur, all of them will get result from the first call. Default value
  is set to `false`;
- `limit` - limit how many results for different method call arguments combination will be cached. Default value null,
  means no limit.
- `where` - function triggered before caching the value. If returns `true`: value will be cached, if returns `false`: value wil be ignored. Useful to signal that a certain result must not be cached, but `@IgnoreCache` is not enough (e.g. condition whether or not to cache known once acquiring data)
- `persistentStorage` - Defines optional usage of external persistent storage (e.g. shared preferences). If set to `true` in order to work, you have to set `PersistentStorageHolder.storage` in your main.dart file. Check the [Persistent storage section](#persistent-storage) of this README for more information.

#### Example

```dart
@Cached(
  ttl: 60,
  syncWrite: true,
  limit: 100,
)
Future<int> getInt(String param) {
  return Future.value(1);
}
```

#### Example with getter

```dart
@cached
Future<int> get getter {
  return Future.value(1);
}
```

#### where

As mentioned before, `where` takes top-level function to check whether to cache value or not. It also supports `async` calls, so feel free to create conditional caching based on e.g. `http` response parsing.

##### sync example

```dart
@Cached(
  ttl: 60,
  syncWrite: true,
  limit: 100,
  where: _shouldCache
)
int getInt(String param) {
  return 1;
}

bool _shouldCache(int candidate) {
  return candidate > 0;
}
```

##### async example

```dart
@Cached(
  where: _asyncShouldCache,
)
Future<http.Response> getDataWithCached() {
  return http.get(Uri.parse(_url));
}

Future<bool> _asyncShouldCache(http.Response response) async {
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  print('Up to you: check conditionally and decide if should cache: $json');

  print('For now: always cache');
  return true;
}

```

### IgnoreCache

That annotation must be above a field in a method and must be bool,
if `true` the cache will be ignored

Example use:

```dart
@cached
Future<int> getInt(String param, {@ignoreCache bool ignoreCache = false}) {
  return Future.value(1);
}
```

or you can use with `useCacheOnError` in the annotation and if set `true`
then return the last cached value when an error occurs.

```dart
@cached
Future<int> getInt(String param, {@IgnoreCache(useCacheOnError: true) bool ignoreCache = false}) {
  return Future.value(1);
}
```

Possible reason why the generator gives an error

- if method has multiple `@ignoreCache` annotation

### Ignore

That annotation must be above a field in a method,
arguments with `@ignore` annotations will be ignored while generating cache key.

Example use:

```dart
@cached
Future<int> getInt(@ignore String param) {
  return Future.value(1);
}
```

### CacheKey

That annotation must be above a field in a method and must contain constant function that will
return cache key for provided field value

Example use:

```dart
@cached
Future<int> getInt(@CacheKey(exampleCacheFunction) int test) async {
  await Future.delayed(Duration(milliseconds: 20));
  return test;
}

String exampleCacheFunction(dynamic value) {
  return value.toString();
}
```

You can also use `@iterableCacheKey`, which will generate cache key from `Iterable<T>` values

Example use:

```dart
@cached
Future<List<int>> getInt(@iterableCacheKey List<int> test) async {
  await Future.delayed(Duration(milliseconds: 20));
  return test;
}
```

### ClearCached

Method decorator that flag it as needing to be processed by `Cached` code generator.
Method annotated with this annotation can be used to clear result of method annotated with `Cached` annotation.
\
Constructor of this annotation can take one possible argument. It is method name, that we want to clear the cache.

Let say there is existing cached method:

```dart
@Cached()
Future<SomeResponseType> getUserData() {
  return userDataSource.getData();
}
```

to generate clearing cache method we can write:

```dart
@clearCached
void clearGetUserData();
```

or

```dart
@ClearCached('getUserData')
void clearUserData();
```

The `ClearCached` argument or method name has to correspond to cached method name. We can also create a method that
returns a bool, and then write our own logic to check if the cache should be cleared or not.

```dart
@ClearCached('getUserData')
Future<bool> clearUserData() {
  return userDataSource.isLoggedOut();
};
```

If the user is logged out, the user cache will be cleared.

Possible reasons why the generator gives an error

- if method with `@cached` annotation doesn’t exist
- if method to pair doesn’t exist
- if method don’t return `bool`, `Future<bool>` or not a `void`, `Future<void>`

### ClearAllCached

This is exactly the same as `ClearCached`, except you don't pass any arguments and you don't add a clear statement
before the method name, all you have to do is add `@clearAllCached` above the method, this annotation will clear cached
values for all methods in the class with the `@WithCache`.

Here is a simple example:

```dart
@clearAllCached
void clearAllData();
```

or we can also create a method that returns a bool, and then write our own logic to check if cached values for all
methods will be cleared

```dart
@clearAllCached
Future<bool> clearAllData() {
  return userDataSource.isLoggedOut();
}
```

If the user is logged out, will clear cached values for all methods

Possible reasons why the generator gives an error

- if we have too many `clearAllCached` annotation, only one can be
- if method don’t return `bool`, `Future<bool>` or not a `void`

### StreamedCache

Use `@StreamedCache` annotation to get a stream of cache updates from a cached method.
Remember to provide at least the name of the cached class method in the `methodName` parameter.

Simple example of usage:

```dart
@cached
int cachedMethod() {
  return 1;
}

@StreamedCache(methodName: "cachedMethod", emitLastValue: true)
Stream<int> cachedStream();
```

Method annotated with `@StreamedCache` should have same parameters (except `@ignore` or `@ignoreCache`)
as method provided in `methodName` parameter, otherwise `InvalidGenerationSourceError` will be thrown.
Return type of this method should be a `Stream<sync type of target method>` - for example for `Future<String>`
the return type will be `Stream<String>`

Example:

```dart
@cached
Future<String> cachedMethod(int x, @ignore String y) async {
  await Future.delayed(Duration(miliseconds: 100));
  return x.toString();
}

@StreamedCache(methodName: "cachedMethod", emitLastValue: false)
Stream<String> cachedStream(int x);
```

### CachePeek

Method decorator that flag it as needing to be processed by `Cached` code generator.
Method annotated with this annotation can be used to peek result of method annotated with `Cached` annotation.

Constructor of this annotation can take one possible argument. It is method name, that we want to peek the cache.

Let say there is existing cached method:

```dart
@Cached()
Future<SomeResponseType> getUserData() {
  return userDataSource.getData();
}
```

to generate peek cache method we can write:

```dart
@CachePeek("getUserData")
SomeResponseType? peekUserDataCache();
```

The `CachePeek` methodName argument has to correspond to cached method name

Possible reasons why the generator gives an error

- if more then one method is targeting [Cached] method cache
- if method return type is incorrect
- if method has different parameters then target function (excluding [Ignore], [IgnoreCache])
- if method is not abstract

### DeletesCache

@DeletesCache annotaton is a method decorator that marks method to be processed by code generator. Methods preceeded by this annotation clear the cache of all specified methods, annotated with @Cached, if they complete with result.

@DeletesCache annotation takes a list of cached methods that are affected by the use of annotated method, the cache of all specified methods is cleared on method success, but if an error occurs, the cache is not deleted and the error is rethrown.

If there is a cached method:

```dart
@Cached()
Future<SomeResponseType> getSthData() {
  return dataSource.getData();
}
```

Then a method that affects the cache of this method can be written as:

```dart
@DeletesCache(['getSthData'])
Future<SomeResponseType> performOperation() {
  ...
  return data;
}
```

All methods specified in @DeletesCache annotation must correspond to cached method names. If the performOperation method completes without an error, then the cache of getSthData will be cleared.

Throws an [InvalidGenerationSourceError]

- if method with @cached annotation doesn't exist
- if no target method names are specified
- if specified target methods are invalid
- if annotated method is abstract

## Persistent storage
Cached library supports usage of any external storage (e.g. Shared Preferences, Hive), by passing `persistentStorage: true` parameter into `@Cached()` annotation:

```dart
  @Cached(persistentStorage: true)
  Future<double> getDouble() async {
    return await _source.nextDouble() ;
  }
```

You only have to provide a proper interface by extending `CachedStorage` abstraction, e.g.:

```dart
...
import 'package:cached_annotation/cached_annotation.dart';

class MyStorageImpl extends CachedStorage {
  final _storage = MyExternalStorage();

  @override
  Future<Map<String, dynamic>> read(String key) async {
    return await _storage.read(key);
  }

  @override
  Future<void> write(String key, Map<String, dynamic> data) async {
    await _storage.write(key, data);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
```

Now you have to assign instance of your class (preferably on the top of your `main` method):

```dart
...
import 'package:cached_annotation/cached_annotation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PersistentStorageHolder.storage = await MyStorageImpl();
  
  runApp(const MyApp());
}
```

As you can see above, Cached doesn't provide any generic way of error or typing handling. It'll just use `PersistentStorageHolder.storage` to save and read cached data from storage in generated code. You have to take care of it yourself inside your code.  

Data saved to persistent storage can be deleted by using `@ClearCached()`, `@ClearAllCached()` or `@DeletesCache` annotations.

Usage of persistent storage does not change this library caching behaviour in any way. It only adds new capabilities, but it can affect the way in which you implement your app:

> **Important:** 
> 
> Please note, that persistent storage usage enforces you to provide async API when using Cached annotations! 

For sample project, please check `persistent_storage_example` inside `cached/example` directory. 

## Contribution

We accept any contribution to the project!

Suggestions of a new feature or fix should be created via pull-request or issue.

### feature request

- Check if feature is already addressed or declined

- Describe why this is needed

  Just create an issue with label `enhancement` and descriptive title. Then, provide a description and/or example code.
  This will help the community to understand the need for it.

- Write tests for your feature

  The test is the best way to explain how the proposed feature should work. We demand a complete test before any code is
  merged in order to ensure cohesion with existing codebase.

- Add it to the README and write documentation for it

  Add a new feature to the existing featrues table and append sample code with usage.

### Fix

- Check if bug was already found

- Describe what is broken

  The minimum requirement to report a bug fix is a reproduction path. Write steps that should be followed to find a
  problem in code. Perfect situation is when you give full description why some code doesn’t work and a solution code.

## Contributors

<div align="left">
  <a href="https://github.com/Iteo/cached/graphs/contributors">
   <img src="https://contrib.rocks/image?repo=Iteo/cached"/>
  </a>
</div>