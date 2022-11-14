import 'package:meta/meta_meta.dart';

/// {@template cached.deletes_cache}
/// #### DeletesCache
///
/// Annotation for for 'Cached package'.
///
/// Throws an [InvalidGenerationSourceError]
/// * if method with @cached annotation doesn't exist
/// * if no target method names are specified
/// * if specified target methods are invalid
/// * if annotated class is abstract
///
/// ### Example
///
/// If there's a method with @Cached() annotation
///
/// ```dart
/// @Cached()
/// Future<SomeResponseType> getSthData() {
///   return dataSource.getData();
/// }
/// ```
///
/// If you have a method that alters the cached data, then to clear the cache
/// of affected methods on successful operation just place the '@DeletesCache'
/// annotation before method declaration, and specify methods that are
/// affected by the use of this method in method arguments
///
/// ```dart
/// @DeletesCache(['getSthData'])
/// Future<SomeResponseType> performOperation() {
///   ...
///   return data;
/// }
/// ```
///
/// The cache of the specified methods will be cleared if the method annotated
/// with @DeletesCache completes without throwing an error,
/// but if an error occurs, the cache is not deleted and the error is rethrown.
///
/// {@endtemplate}
@Target({TargetKind.method, TargetKind.getter})
class DeletesCache {
  /// {@macro cached.deletes_cache}
  const DeletesCache(this.methodNames);

  /// Name of methods whose cache is altered by this method
  final List<String> methodNames;
}
