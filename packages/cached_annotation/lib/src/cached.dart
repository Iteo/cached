import 'package:meta/meta_meta.dart';

/// const instance of [Cached]
const cached = Cached();

/// {@template cached.cached}
/// ### Cached
///
/// Annotation for `Cached` package.
///
/// Method decorator that flag it as needing to be processed
/// by `Cached` code generator.
///
/// Throws an [InvalidGenerationSourceError]
/// * if we have multiple [IgnoreCache] annotations in method
///
/// ### Example
///
/// Use @cached annotation
///
/// ```dart
/// @cached
/// Future<SomeResponseType> getSthData() {
///   return dataSource.getData();
/// }
/// ```
///
/// or with parameters
///
/// ```dart
/// @Cached(syncWrite: true, ttl: 30, limit: 10)
/// Future<SomeResponseType> getSthData() {
///   return dataSource.getData();
/// }
/// ```
///
/// if you want to clear cache method use [ClearCached]
/// or [ClearAllCached] annotation
/// {@endtemplate}
@Target({TargetKind.method})
class Cached {
  /// {@macro cached.cached}
  const Cached({
    this.limit,
    this.syncWrite,
    this.ttl,
  });

  /// limit how many results for different method call
  /// arguments combination will be cached.
  /// Default value null, means no limit.
  final int? limit;

  /// time to live. In seconds.
  /// Set how long cache will be alive.
  /// Default value is set to null, means infinitive ttl.
  final int? ttl;

  /// Affects only async methods (those one that returns Future)
  /// If set to true first method call will be cached,
  /// and if following ( the same ) call will occur,
  /// all of them will get result from the first call.
  /// Default value is set to `false`.
  final bool? syncWrite;
}
