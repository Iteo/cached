import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:cached/src/config.dart';
import 'package:cached/src/models/param.dart';
import 'package:cached/src/utils/asserts.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _defaultSyncWriteValue = false;

class CachedMethod {
  CachedMethod({
    required this.name,
    required this.syncWrite,
    required this.isAsync,
    required this.isGenerator,
    required this.returnType,
    required this.params,
    this.limit,
    this.ttl,
  });

  final String name;
  final bool syncWrite;
  final String returnType;
  final bool isGenerator;
  final bool isAsync;
  final Iterable<Param> params;
  final int? limit;
  final int? ttl;

  factory CachedMethod.fromElement(MethodElement element, Config config) {
    assertMethodNotVoid(element);
    assertMethodIsNotAbstract(element);
    final annotation = getAnnotation(element);

    bool? syncWrite;
    int? limit;
    int? ttl;

    if (annotation != null) {
      final reader = ConstantReader(annotation);
      final syncWriteField = reader.read('syncWrite');
      final limitField = reader.read('limit');
      final ttlField = reader.read('ttl');

      if (syncWriteField.isBool) {
        syncWrite = syncWriteField.boolValue;
      }
      if (limitField.isInt) {
        limit = limitField.intValue;
      }
      if (ttlField.isInt) {
        ttl = ttlField.intValue;
      }
    }

    final method = CachedMethod(
      name: element.name,
      syncWrite: syncWrite ?? config.syncWrite ?? _defaultSyncWriteValue,
      limit: limit ?? config.limit,
      ttl: ttl ?? config.ttl,
      returnType: element.returnType.getDisplayString(withNullability: true),
      isAsync: element.isAsynchronous,
      isGenerator: element.isGenerator,
      params: element.parameters.map((e) => Param.fromElement(e, config)),
    );
    assertOneIgnoreCacheParam(method);

    return method;
  }

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(Cached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
