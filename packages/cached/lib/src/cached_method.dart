import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:cached/src/config.dart';
import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _defaultSyncWriteValue = false;

class CachedMethod {
  CachedMethod({
    required this.name,
    required this.syncWrite,
    this.limit,
    this.ttl,
  });

  final String name;
  final bool syncWrite;
  final int? limit;
  final int? ttl;

  factory CachedMethod.fromElement(MethodElement element, Config config) {
    final isFuture = element.returnType.isDartAsyncFuture || element.returnType.isDartAsyncFutureOr;
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


    if (!isFuture) {
      syncWrite = false;
    }
  
    return CachedMethod(
      name: element.name,
      syncWrite: syncWrite ?? config.syncWrite ?? _defaultSyncWriteValue,
      limit: limit ?? config.limit,
      ttl: ttl ?? config.ttl,
    );
  }

  static DartObject? getAnnotation(MethodElement element) {
    const methodAnnotationChecker = TypeChecker.fromRuntime(Cached);
    return methodAnnotationChecker.firstAnnotationOf(element);
  }
}
