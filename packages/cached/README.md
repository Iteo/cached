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


[![Test status](https://github.com/Iteo/cached/workflows/Build/badge.svg)](https://github.com/Iteo/cached/actions/workflows/build.yml)

---

# Cached

Simple Flutter package with build-in code generation. It simplifies and speedup creation of cache mechanism for dart
classes.

## Least Recently Used (LRU) cache algorithm

It is a finite key-value map using
the [Least Recently Used (LRU)](http://en.wikipedia.org/wiki/Cache_algorithms#Least_Recently_Used) algorithm, where the
most recently-used items are "kept alive" while older, less-recently used items are evicted to make room for newer
items.

Useful when you want to limit use of memory to only hold commonly-used things or cache some API calls.

## Contents

<!-- pub.dev accepts anchors only with lowercase -->

- [Motivation](#motivation)
- [Setup](#setup)
- [Usage](#usage)
- [Contribution](#contribution)

## Motivation

There is quite often situation, that you have to cache something in memory for later usage. Common case is cache some
API calls and theirs responses.
Usually, it is done in some data layer, probably in - let say -  `RemoteRepository`

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
    return  dataSource.getData();
  }
}
```


## Contribution

We accept any contribution to the project!

Suggestions of a new feature or fix should be created via pull-request or issue.

### feature request:

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
  problem in code. Perfect situation is when you give full description why some code doesn't work and a solution code.

## Contributors

<div align="left">
  <a href="https://github.com/Iteo/cached/graphs/contributors">
   <img src="https://contrib.rocks/image?repo=Iteo/cached"/>
  </a>
</div>