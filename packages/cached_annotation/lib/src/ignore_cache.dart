import 'package:meta/meta_meta.dart';

/// const instance of [IgnoreCache]
const ignoreCache = IgnoreCache();

/// {@template cached.ignore_cache}
/// ### IgnoreCache
///
/// Annotation for `Cached` package.
///
/// Annotation that must be above a field in a method and must be bool,
/// if true the cache will be ignored
///
/// ### Example
///
/// Use @ignoreCache annotation
///
/// ```dart
/// @cached
/// Future<int> getInt(String param, {@ignoreCache bool ignoreCache = false}) {
///   return Future.value(1);
/// }
/// ```
///
/// or with `useCacheOnError` in the annotation and if set `true`
/// then return the last cached value when an error occurs.
///
/// ```dart
/// Future<int> getInt(String param, {@IgnoreCache(useCacheOnError: true) bool ignoreCache = false}) {
///   return Future.value(1);
/// }
/// ```
/// {@endtemplate}
@Target({TargetKind.parameter})
class IgnoreCache {
  /// {@macro cached.ignore_cache}
  const IgnoreCache({
    this.useCacheOnError,
  });

  /// If set `true` then return the last cached value when an error occurs.
  final bool? useCacheOnError;
}
