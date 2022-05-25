import 'package:meta/meta_meta.dart';

/// const instance of [ClearCached]
/// with default arguments
const clearCached = ClearCached();

/// {@template cached.clear_cached}
/// ### ClearCache
///
/// Annotation for `Cached` package.
///
/// Throws an [InvalidGenerationSourceError]
/// * if method with @cached annotation doesn’t exist
/// * if method to pair doesn’t exist
/// * if method don't return bool, Future<bool> or not a void
///
/// ### Example
///
/// We have a method with @Cached() annotation
///
/// ```dart
/// @Cached()
/// Future<SomeResponseType> getSthData() {
///   return  dataSource.getData();
/// }
/// ```
///
/// to clear cache this method, we just add `clear` phrase before name method
///
/// ```dart
/// @clearCached
/// void clearGetSthData();
/// ```
///
/// or we can use annotation with argument, then the method name doesn't matter,
/// we just need to add the name of the method we want to clean to the argument
///
/// ```dart
/// @ClearCached("getSthData")
/// void clearMe();
/// ```
/// {@endtemplate}
@Target({TargetKind.method})
class ClearCached {
  /// {@macro cached.clear_cached}
  const ClearCached([this.methodName]);

  /// Name of method to be cache clear
  final String? methodName;
}
