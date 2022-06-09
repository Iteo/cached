import 'package:meta/meta_meta.dart';

/// const instance of [Ignore]
const ignore = Ignore();

/// {@template cached.ignore}
/// ### Ignore
///
/// Annotation for `Cached` package.
///
/// Annotation that must be above a field in a method
/// Arguments with @ignore annotations will be ignored while generating cache key
///
/// ### Example
///
/// Use @ignore annotation
///
/// ```dart
/// @cached
/// Future<int> getInt(@ignore String param) {
///   return Future.value(1);
/// }
/// ```
///
/// ```
/// {@endtemplate}
@Target({TargetKind.parameter})
class Ignore {
  /// {@macro cached.ignore}
  const Ignore();
}
