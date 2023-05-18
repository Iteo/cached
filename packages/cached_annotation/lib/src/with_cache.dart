import 'package:meta/meta_meta.dart';

/// const instance of [WithCache]
const withCache = WithCache();

/// {@template cached.with_cache}
/// ### WithCache
///
/// Annotation for `Cached` package.
///
/// Annotating a class with `@WithCache` will flag
/// it as a needing to be processed by `Cached` code generator.
///
/// It can take one additional boolean parameter `useStaticCache`.
/// If this parameter is set to true, generator will generate
/// cached class with static cache.
/// It means each instance of this class will have access
/// to the same cache. Default value is set to `false`
///
/// Throws an [InvalidGenerationSourceError]
/// * if class has to many constructors. Class can have only one constructor
///
/// ### Example
///
/// Use @withCache annotation
///
/// ```dart
/// @withCache
/// abstract mixin class Gen implements _$Gen {
///   ...
/// }
/// ```
///
/// or with parameters
///
/// ```
/// @WithCache(useStaticCache: true)
/// abstract mixin class Gen implements _$Gen {
///   ...
/// }
/// ```
///
/// do not forget add
/// ```dart
/// part '<file_name>.cached.dart';
/// ```
///
/// if you want to cache method use [Cached] annotation
/// {@endtemplate}
@Target({TargetKind.classType})
class WithCache {
  /// {@macro cached.with_cache}
  const WithCache({
    this.useStaticCache,
  });

  /// If this parameter is set to true,
  /// generator will generate cached class with static cache.
  /// It means each instance of this class will have access
  /// to the same cache. Default value is set to `false`.
  final bool? useStaticCache;
}
