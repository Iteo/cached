import 'package:cached_annotation/src/persistent_cached.dart';
import 'package:meta/meta_meta.dart';

/// const instance of [LazyPersistentCached]
const lazyPersistentCached = LazyPersistentCached();

/// {@template cached.lazy_cached}
/// ### LazyPersistentCached
///
/// Annotation for `Cached` package.
///
/// Method decorator that flag it as needing to be processed
/// by `Cached` code generator.
///
/// Throws an [InvalidGenerationSourceError]
/// * if we have multiple [IgnoreCache] annotations in method
///
/// Defines usage of external persistent storage (e.g. shared preferences)
///
/// You have to set `PersistentStorageHolder.storage` in your main.dart file
///
/// Important:
/// If you want to utilize persistent storage, all methods which use
/// Cached library's annotations has to be async
/// ### Example
///
/// Use @lazyPersistentCached annotation
///
/// ```dart
/// @LazyPersistentCached()
/// Future<SomeResponseType> getSthData() {
///   return dataSource.getData();
/// }
/// ```
///
/// if you want to clear cache method use [ClearCached]
/// or [ClearAllCached] annotation
/// {@endtemplate}
@Target({TargetKind.method, TargetKind.getter})
class LazyPersistentCached extends PersistentCached {
  /// {@macro cached.persistentCached}
  const LazyPersistentCached() : super();
}
