import 'package:cached_annotation/cached_annotation.dart';
import 'package:meta/meta_meta.dart';

/// const instance of [PersistentCached]
const persistentCached = PersistentCached();

/// {@template cached.cached}
/// ### PersistentCached
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
/// Use @persistentCached annotation
///
/// ```dart
/// @persistentCached
/// Future<SomeResponseType> getSthData() {
///   return dataSource.getData();
/// }
/// ```
///
/// or with parameters
///
/// ```dart
/// @PersistentCached(lazy: true)
/// Future<SomeResponseType> getSthData() {
///   return dataSource.getData();
/// }
/// ```
///
/// if you want to clear cache method use [ClearCached]
/// or [ClearAllCached] annotation
/// {@endtemplate}
@Target({TargetKind.method, TargetKind.getter})
class PersistentCached extends Cached {
  /// {@macro cached.persistentCached}
  const PersistentCached({
    super.limit,
    super.ttl,
    super.syncWrite,
    super.where,
  });
}
