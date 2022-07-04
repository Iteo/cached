import 'package:meta/meta_meta.dart';

/// {@template cached.streamed_cache}
/// ### StreamedCache
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
/// ### Example
///
/// Use `@StreamedCache` annotation:
///
/// In this example, cachedStream will return stream of cache updates from cachedMethod
///
/// ```dart
/// @withCache
/// abstract class EmitLastValue {
///   factory EmitLastValue() = _EmitLastValue;
///
///   @cached
///   int cachedMethod() {
///     return 1;
///   }
///
///   @StreamedCache(methodName: "cachedMethod", emitLastValue: true)
///   Stream<int> cachedStream();
/// }
/// ```
///
/// {@endtemplate}
@Target({TargetKind.method})
class StreamedCache {
  /// {@macro cached.cached}
  const StreamedCache({
    required this.methodName,
    this.emitLastValue = false,
  });

  /// Name of class method.
  final String methodName;

  /// If true, last value from cache (if exists) will be emitted.
  final bool emitLastValue;
}

/// {@template cached.stream_event_id}
/// Class that is used by generated code to identify events in stream.
/// 
/// This class should not be used outside of generated code
/// {@endtemplate}
class StreamEventIdentifier<T> {
  /// {@macro cached.stream_event_id}
  const StreamEventIdentifier({
    this.instance,
    this.paramsKey,
  });

  /// Instance
  final T? instance;
  /// Key
  final String? paramsKey;
}
