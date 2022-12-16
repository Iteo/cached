import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/models/cached_function.dart';
import 'package:cached/src/models/check_if_should_cache_method.dart';
import 'package:source_gen/source_gen.dart';

class CachedFunctionLocalConfig {
  factory CachedFunctionLocalConfig.fromElement(ExecutableElement element) {
    final cachedAnnotation = CachedFunction.getAnnotation(element);
    if (cachedAnnotation != null) {
      return _build(cachedAnnotation, element);
    }

    const message = '[ERROR] Expected @Cached annotation with parameters';
    throw InvalidGenerationSourceError(message);
  }

  CachedFunctionLocalConfig._({
    required this.syncWrite,
    required this.limit,
    required this.ttl,
    required this.checkIfShouldCacheMethod,
    required this.persistentStorage,
  });

  bool? syncWrite;
  int? limit;
  int? ttl;
  CheckIfShouldCacheMethod? checkIfShouldCacheMethod;
  bool? persistentStorage;

  static CachedFunctionLocalConfig _build(
    DartObject cachedAnnotation,
    ExecutableElement element,
  ) {
    final reader = ConstantReader(cachedAnnotation);

    bool? syncWrite;
    int? limit;
    int? ttl;
    CheckIfShouldCacheMethod? checkIfShouldCacheMethod;
    bool? persistentStorage;

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
      checkIfShouldCacheMethod = _checkIfShouldCacheMethod(
        element,
        shouldCacheFunctionField,
      );
    }

    final shouldUseStorage = reader.peek('persistentStorage');
    if (shouldUseStorage != null && shouldUseStorage.isBool) {
      persistentStorage = shouldUseStorage.boolValue;
    }

    return CachedFunctionLocalConfig._(
      ttl: ttl,
      limit: limit,
      syncWrite: syncWrite,
      checkIfShouldCacheMethod: checkIfShouldCacheMethod,
      persistentStorage: persistentStorage,
    );
  }

  static CheckIfShouldCacheMethod _checkIfShouldCacheMethod(
    ExecutableElement element,
    ConstantReader field,
  ) {
    final objectValue = field.objectValue;
    final shouldCacheFunction = objectValue.toFunctionValue();

    if (shouldCacheFunction == null) {
      final message = '[ERROR] Expected $objectValue to be a function.';
      throw InvalidGenerationSourceError(message);
    }

    return CheckIfShouldCacheMethod.fromElements(
      annotatedMethod: element,
      shouldCacheFunction: shouldCacheFunction,
    );
  }
}
