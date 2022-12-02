import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/check_if_should_cache_method.dart';
import 'package:source_gen/source_gen.dart';

class CachedFunctionLocalConfig {
  CachedFunctionLocalConfig._({
    required this.syncWrite,
    required this.limit,
    required this.ttl,
    required this.checkIfShouldCacheMethod,
  });

  bool? syncWrite;
  int? limit;
  int? ttl;
  CheckIfShouldCacheMethod? checkIfShouldCacheMethod;

  factory CachedFunctionLocalConfig.fromElement(
    ExecutableElement element,
  ) {
    final cachedAnnotation = CachedFunction.getAnnotation(element);
    if (cachedAnnotation != null) {
      final reader = ConstantReader(cachedAnnotation);

      bool? syncWrite;
      int? limit;
      int? ttl;
      CheckIfShouldCacheMethod? checkIfShouldCacheMethod;

      final syncWriteField = reader.peek('syncWrite');
      if (syncWriteField != null) {
        syncWrite = syncWriteField.boolValue;
      }

      final limitField = reader.peek('limit');
      if (limitField != null) {
        limit = limitField.intValue;
      }

      final ttlField = reader.peek('ttl');
      if (ttlField != null) {
        ttl = ttlField.intValue;
      }

      final shouldCacheFunctionField = reader.peek('where');
      if (shouldCacheFunctionField != null) {
        final shouldCacheFunctionObject = shouldCacheFunctionField.objectValue;
        final shouldCacheFunction = shouldCacheFunctionObject.toFunctionValue();
        if (shouldCacheFunction == null) {
          throw InvalidGenerationSourceError(
            '[ERROR] Expected $shouldCacheFunctionObject to be a function.',
          );
        }

        checkIfShouldCacheMethod = CheckIfShouldCacheMethod.fromElements(
          annotatedMethod: element,
          shouldCacheFunction: shouldCacheFunction,
        );
      }

      return CachedFunctionLocalConfig._(
        ttl: ttl,
        limit: limit,
        syncWrite: syncWrite,
        checkIfShouldCacheMethod: checkIfShouldCacheMethod,
      );
    }
    throw InvalidGenerationSourceError(
      '[ERROR] Expected @Cached annotation with parameters',
    );
  }
}
