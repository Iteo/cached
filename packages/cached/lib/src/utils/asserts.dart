import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_all_cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/utils/utils.dart';
import 'package:source_gen/source_gen.dart';

void assertMethodNotVoid(MethodElement element) {
  if (element.returnType.isVoid ||
      element.returnType.getDisplayString(withNullability: false) ==
          'Future<void>') {
    throw InvalidGenerationSourceError(
      '[ERROR] Method ${element.name} returns void or Future<void> which is not allowed',
      element: element,
    );
  }
}

void assertMethodIsNotAbstract(MethodElement element) {
  if (element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] Cached method ${element.name} is abstract which is not allowed',
      element: element,
    );
  }
}

void assertAbstract(ClassElement element) {
  if (!element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] Class ${element.name} need to be abstract',
      element: element,
    );
  }
}

void assertOneIgnoreCacheParam(CachedMethod method) {
  final ignoraCacheParams =
      method.params.where((element) => element.ignoreCacheAnnotation != null);

  if (ignoraCacheParams.length > 1) {
    throw InvalidGenerationSourceError(
      '[ERROR] Multiple IgnoreCache annotations in ${method.name} method',
    );
  }
}

void assertOneConstFactoryConstructor(ClassElement element) {
  final constructorElements = element.constructors;

  if (constructorElements.length != 1) {
    throw InvalidGenerationSourceError(
      '[ERROR] To many constructors in ${element.name} class. Class can have only one constructor',
      element: element,
    );
  }

  final constructor = constructorElements.first;

  if (!constructor.isFactory) {
    throw InvalidGenerationSourceError(
      '[ERROR] Class ${element.name} need to have one factory constructor',
      element: element,
    );
  }
}

void assertOneClearAllCachedAnnotation(
  Iterable<ClearAllCachedMethod> clearAllMethod,
) {
  if (clearAllMethod.length > 1) {
    throw InvalidGenerationSourceError(
      '[ERROR] Too many `clearAllCached` annotation, only one can be',
    );
  }
}

void assertValidateClearCachedMethods(
  Iterable<ClearCachedMethod> clearMethods,
  Iterable<CachedMethod> methods,
) {
  for (final ClearCachedMethod clearMethod in clearMethods) {
    final hasPair = methods
        .where((element) => element.name == clearMethod.methodName)
        .isNotEmpty;

    if (!hasPair) {
      throw InvalidGenerationSourceError(
        '[ERROR] No cache method for `${clearMethod.name}` method',
      );
    }

    if (clearMethods
            .where((element) => element.methodName == clearMethod.methodName)
            .length >
        1) {
      throw InvalidGenerationSourceError(
        '[ERROR] There are multiple methods which ClearCached annotation with the same argument',
      );
    }
  }
}

void assertCorrectClearMethodType(MethodElement element) {
  if (element.isAbstract) {
    if (element.isAsynchronous) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` must be not async method',
        element: element,
      );
    }

    if (!element.returnType.isVoid) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` must be a void method',
        element: element,
      );
    }

    if (element.parameters.isNotEmpty) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` method cant have arguments',
        element: element,
      );
    }
  } else {
    final returnType =
        element.returnType.getDisplayString(withNullability: true);
    if (!isVoid(returnType) &&
        !isBool(returnType) &&
        !isAsyncVoid(returnType) &&
        !isFutureBool(returnType)) {
      throw InvalidGenerationSourceError(
        '[ERROR] `${element.name}` return type must be a void, Future<void>, bool, Future<bool>',
        element: element,
      );
    }
  }
}

void assertOneCacheStreamPerCachedMethod(
  Iterable<MethodElement> methods,
  Iterable<StreamedCacheMethod> streamedCacheMethods,
) {
  for (final method in methods) {
    final methodName = method.name;
    final referencingStreamedCacheMethods =
        streamedCacheMethods.where((s) => s.targetMethodName == methodName);

    if (referencingStreamedCacheMethods
            .where((s) => s.targetMethodName == methodName)
            .length >
        1) {
      throw InvalidGenerationSourceError(
        '[ERROR] `$methodName` cannot be targeted by multiple @StreamedCache methods',
        element: method,
      );
    }
  }
}

void assertOneCachePeekPerCachedMethod(
  Iterable<MethodElement> methods,
  Iterable<CachePeekMethod> cachePeekMethods,
) {
  for (final method in methods) {
    final methodName = method.name;
    final referencingCachePeekMethods =
        cachePeekMethods.where((s) => s.targetMethodName == methodName);

    if (referencingCachePeekMethods
            .where((s) => s.targetMethodName == methodName)
            .length >
        1) {
      throw InvalidGenerationSourceError(
        '[ERROR] `$methodName` cannot be targeted by multiple @CachePeek methods',
        element: method,
      );
    }
  }
}

void assertCorrectStreamMethodType(MethodElement element) {
  if (!element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] `${element.name}` must be a abstract method',
      element: element,
    );
  }
}

void assertCorrectCachePeekMethodType(MethodElement element) {
  if (!element.isAbstract) {
    throw InvalidGenerationSourceError(
      '[ERROR] `${element.name}` must be a abstract method',
      element: element,
    );
  }
}
