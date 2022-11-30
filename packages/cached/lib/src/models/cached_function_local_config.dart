import 'package:analyzer/dart/constant/value.dart';
import 'package:cached/src/models/check_if_should_cache_method.dart';
import 'package:source_gen/source_gen.dart';

class CachedFunctionLocalConfig {
  CachedFunctionLocalConfig({
    required this.syncWrite,
    required this.limit,
    required this.ttl,
    required this.checkIfShouldCacheMethod,
  });

  bool? syncWrite;
  int? limit;
  int? ttl;
  CheckIfShouldCacheMethod? checkIfShouldCacheMethod;

  factory CachedFunctionLocalConfig.fromAnnotation(
    DartObject? annotation,
  ) {
    bool? syncWrite;
    int? limit;
    int? ttl;
    CheckIfShouldCacheMethod? checkIfShouldCacheMethod;

    if (annotation != null) {
      final reader = ConstantReader(annotation);

      syncWrite = reader.peek('syncWrite')?.boolValue;
      limit = reader.peek('limit')?.intValue;
      ttl = reader.peek('ttl')?.intValue;
    }

    return CachedFunctionLocalConfig(
      ttl: ttl,
      limit: limit,
      syncWrite: syncWrite,
      checkIfShouldCacheMethod: checkIfShouldCacheMethod,
    );
  }
}
