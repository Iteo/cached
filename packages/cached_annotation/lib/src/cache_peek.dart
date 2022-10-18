import 'package:meta/meta_meta.dart';

/// {@template cached.cache_peek}
/// ### CachePeek
///
/// Annotation for `Cached` package.
///
/// Throws an [InvalidGenerationSourceError]
/// * if more then one method is targeting [Cached] method cache
/// * if method return type is incorrect
/// * if method has different parameters then target function (excluding
/// [Ignore], [IgnoreCache])
/// * if method is not abstract
///
/// Example
///
/// Use @CachePeek annotation
///
/// In this example, peekSthDataCache will return cache data from getDataWithCached method
///
/// ```dart
/// @CachePeek(methodName: "getDataWithCached")
/// SomeResponseType? peekSthDataCache();
/// ```
///
/// {@endtemplate}
@Target({TargetKind.method})
class CachePeek {
  /// {@macro cached.cache_peek}
  const CachePeek({
    required this.methodName,
  });

  /// Name of method to be cache peek
  final String methodName;
}
