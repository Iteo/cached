import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:source_gen/source_gen.dart';

void assertOneIgnoreCacheParam(CachedMethod method) {
  final ignoraCacheParams = method.params.where((element) => element.ignoreCacheAnnotation != null);

  if (ignoraCacheParams.length > 1) {
    throw InvalidGenerationSourceError(
      'Multiple IgnoreCache annotations in ${method.name} method',
    );
  }
}

void assertOneConstFactoryConstructor(ClassElement element) {
  final constructorElements = element.constructors;

  if (constructorElements.length != 1) {
    throw InvalidGenerationSourceError(
      'To many constructors in ${element.name} class. Class can have only one constructor',
      element: element,
    );
  }

  final constructor = constructorElements.first;

  if (!constructor.isFactory) {
    throw InvalidGenerationSourceError(
      'Class ${element.name} need to have one factory constructor',
      element: element,
    );
  }
}

void assertValidateClearCachedMethods(Iterable<ClearCachedMethod> clearMethods, Iterable<CachedMethod> methods) {
  for (final ClearCachedMethod clearMethod in clearMethods) {
    final hasPair = methods.where((element) => element.name == clearMethod.methodName).isNotEmpty;

    if (!hasPair) {
      throw InvalidGenerationSourceError('["ERROR"] No cache method for `${clearMethod.name}` method');
    }

    if (clearMethods.where((element) => element.methodName == clearMethod.methodName).length > 1) {
      throw InvalidGenerationSourceError(
        '["ERROR"] There are multiple methods which ClearCached annotation with the same argument',
      );
    }
  }
}
