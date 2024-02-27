import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/getters/cached_getter.dart';
import 'package:cached/src/models/getters/lazy_persistent_cached_getter.dart';
import 'package:cached/src/models/getters/persistent_cached_getter.dart';
import 'package:cached/src/models/lazy_persistent_cached_method.dart';
import 'package:cached/src/models/persistent_cached_method.dart';
import 'package:cached_annotation/cached_annotation.dart';

class CachedFunctionsGenerator {
  static Iterable<CachedMethod<Cached>> generateMethods(
    List<MethodElement> methods,
    Config config,
  ) sync* {
    for (final method in methods) {
      if (CachedFunction.hasCachedAnnotation<LazyPersistentCached>(method)) {
        yield LazyPersistentCachedMethod.fromElement(method, config);
      } else if (CachedFunction.hasCachedAnnotation<PersistentCached>(method)) {
        yield PersistentCachedMethod.fromElement(method, config);
      } else if (CachedFunction.hasCachedAnnotation<Cached>(method)) {
        yield CachedMethod<Cached>.fromElement(method, config);
      }
    }
  }

  static Iterable<CachedGetter<Cached>> generateGetters(
    List<PropertyAccessorElement> accessors,
    Config config,
  ) sync* {
    for (final getter in accessors) {
      if (CachedFunction.hasCachedAnnotation<LazyPersistentCached>(getter)) {
        yield LazyPersistentCachedGetter.fromElement(getter, config);
      } else if (CachedFunction.hasCachedAnnotation<PersistentCached>(getter)) {
        yield PersistentCachedGetter.fromElement(getter, config);
      } else if (CachedFunction.hasCachedAnnotation<Cached>(getter)) {
        yield CachedGetter<Cached>.fromElement(getter, config);
      }
    }
  }
}
