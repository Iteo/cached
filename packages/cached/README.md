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
<img width="400" src="https://github.com/Iteo/cached/raw/master/packages/cached/cached_sygnet.png">
<br /><br />

[![Test status](https://github.com/Iteo/cached/workflows/Build/badge.svg)](https://github.com/Iteo/cached/actions/workflows/build.yml)
&nbsp;
[![stars](https://img.shields.io/github/stars/Iteo/cached.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/Iteo/cached)
&nbsp;
[![pub package](https://img.shields.io/pub/v/cached.svg)](https://pub.dartlang.org/packages/cached)
&nbsp;
[![GitHub license](https://img.shields.io/badge/licence-MIT-green)](https://github.com/Iteo/cached/blob/master/packages/cached/LICENSE)
&nbsp;

</div>

---

# Cached

Simple Dart package with build-in code generation. It simplifies and speedup creation of cache
mechanism for dart classes.

## Least Recently Used (LRU) cache algorithm

It is a finite key-value map using
the [Least Recently Used (LRU)](https://en.wikipedia.org/wiki/Cache_algorithms#Least_Recently_Used)
algorithm, where the most recently-used items are "kept alive" while older, less-recently used items
are evicted to make room for newer items.

Useful when you want to limit use of memory to only hold commonly-used things or cache some API
calls.

## Contents

<!-- pub.dev accepts anchors only with lowercase -->

- [Motivation](#motivation)
- [Setup](#setup)
    - [Run the generator](#run-the-generator)
- [Basics](#basics)
    - [withCache](#withcache)
    - [cached](#cached-1)
    - [ignoreCache](#ignorecache)
    - [ignore](#ignore)
    - [clearCached](#clearcached)
    - [clearAllCached](#clearallcached)
    - [StreamedCache](#streamedcache)
- [Contribution](#contribution)

## Motivation

There is quite often situation, that you have to cache something in memory for later usage. Common
case is cache some API calls and theirs responses. Usually, it is done in some data layer, probably
in - let say - `RemoteRepository`

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

#### Install package

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

```
dart run build_runner build
```

For Flutter projects, you can run:

```
flutter pub run build_runner build
```

Note that like most code-generators, [Cached] will need you to both import the
annotation ([cached_annotation])
and use the `part` keyword on the top of your files.

As such, a file that wants to use [Cached] will start with:

```dart
import 'package:cached_annotation/cached_annotation.dart';

part 'some_file.cached.dart';
```

## Basics

### WithCache

Annotation for `Cached` package.

Annotating a class with `@WithCache` will flag it as a needing to be processed by `Cached` code
generator.
\
It can take one additional boolean parameter `useStaticCache`. If this parameter is set to true,
generator will generate cached class with static cache. It means each instance of this class will
have access to the same cache. Default value is set to `false`

```dart
@WithCache(useStaticCache: true)
abstract class Gen implements _$Gen {
  factory Gen() = _Gen;

  ...
}
```

### Cached

Method decorator that flag it as needing to be processed by `Cached` code generator.

There are 3 possible additional parameters:

- `ttl` - time to live. In seconds. Set how long cache will be alive. Default value is set to null,
  means infinitive ttl.
- `syncWrite` - Affects only async methods ( those one that returns Future ) If set to `true` first
  method call will be cached, and if following ( the same ) call will occur, all of them will get
  result from the first call. Default value is set to `false`;
- `limit` - limit how many results for different method call arguments combination will be cached.
  Default value null, means no limit.

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

### IgnoreCache

That annotation must be above a field in a method and must be bool, if `true` the cache will be
ignored

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

That annotation must be above a field in a method, arguments with `@ignore` annotations will be
ignored while generating cache key.

Example use:

```dart
@cached
Future<int> getInt(@ignore String param) {
  return Future.value(1);
}
```

### ClearCached

Method decorator that flag it as needing to be processed by `Cached` code generator. Method
annotated with this annotation can be used to clear result of method annotated with `Cached`
annotation.
\
Constructor of this annotation can take one possible argument. It is method name, that we want to
clear the cache.

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

The `ClearCached` argument or method name has to correspond to cached method name. We can also
create a method that returns a bool, and then write our own logic to check if the cache should be
cleared or not.

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
- if method don’t return `bool`, `Future<bool>` or not a `void`

### ClearAllCached

This is exactly the same as `ClearCached`, except you don't pass any arguments and you don't add a
clear statement before the method name, all you have to do is add `@clearAllCached` above the
method, this annotation will clear cached values for all methods in the class with the `@WithCache`.

Here is a simple example:

```dart
@clearAllCached
void clearAllData();
```

or we can also create a method that returns a bool, and then write our own logic to check if cached
values for all methods will be cleared

```dart
@clearAllCached
Future<bool> clearAllData() {
  return userDataSource.isLoggedOut();
};
```

If the user is logged out, will clear cached values for all methods

Possible reasons why the generator gives an error

- if we have too many `clearAllCached` annotation, only one can be
- if method don’t return `bool`, `Future<bool>` or not a `void`

### Streamed cache

Method annotation that is used to get stream of cache updates from cached method. It takes two
parameters, name of the cached method and if last value from cached should be emitted when creating
new stream.

Simple example of usage:

```dart
@cached
int cachedMethod() {
  return 1;
}

@StreamedCache(methodName: "cachedMethod", emitLastValue: true)
Stream<int> cachedStream();
```

Parameters of cachedMethod should match target method (except @ignore or @ignoreCache),
otherwise `InvalidGenerationSourceError` will be thrown. Return type of method marked
with `@StreamedCache` should be `Stream<sync type of target method>`.

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

## Contribution

We accept any contribution to the project!

Suggestions of a new feature or fix should be created via pull-request or issue.

### feature request:

- Check if feature is already addressed or declined

- Describe why this is needed

  Just create an issue with label `enhancement` and descriptive title. Then, provide a description
  and/or example code. This will help the community to understand the need for it.

- Write tests for your feature

  The test is the best way to explain how the proposed feature should work. We demand a complete
  test before any code is merged in order to ensure cohesion with existing codebase.

- Add it to the README and write documentation for it

  Add a new feature to the existing featrues table and append sample code with usage.

### Fix

- Check if bug was already found

- Describe what is broken

  The minimum requirement to report a bug fix is a reproduction path. Write steps that should be
  followed to find a problem in code. Perfect situation is when you give full description why some
  code doesn’t work and a solution code.

## Contributors

<div align="left">
  <a href="https://github.com/Iteo/cached/graphs/contributors">
   <img src="https://contrib.rocks/image?repo=Iteo/cached"/>
  </a>
</div>
