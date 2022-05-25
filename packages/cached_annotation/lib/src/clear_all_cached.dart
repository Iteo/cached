import 'package:meta/meta_meta.dart';

/// const instance of [ClearAllCached]
const clearAllCached = ClearAllCached();

/// {@template cached.clear_all_cached}
/// ### ClearAllCache
///
/// Annotation for `Cached` package.
///
/// Throws an [InvalidGenerationSourceError]
/// * if we have too many `clearAllCached` annotation, only one can be
/// * if method don't return bool, Future<bool> or not a void
///
/// ### Example
///
/// Use @clearAllCached annotation
/// all methods with @cached annotation will be cleared
///
/// ```dart
/// @clearAllCached
/// void clearAll();
/// ```
///
/// if you want to clear a specify cache method use [ClearCached] annotation
/// {@endtemplate}
@Target({TargetKind.method})
class ClearAllCached {
  /// {@macro cached.clear_all_cached}
  const ClearAllCached();
}
