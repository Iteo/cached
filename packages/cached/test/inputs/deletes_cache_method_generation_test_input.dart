import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow(
  "[ERROR] notCachedMethod is not a valid target for deleteCache",
  element: false,
)
@withCache
abstract class ShouldHaveCachedMethod {
  factory ShouldHaveCachedMethod() = _ShouldHaveCachedMethod;

  Future<int> notCachedMethod(int x) async {
    return 1;
  }

  @DeletesCache(['notCachedMethod'])
  Future<void> deleteCache() async {}
}

@ShouldThrow(
  "[ERROR] No target method names specified for deleteCache",
  element: false,
)
@withCache
abstract class NoMethodsSpecified {
  factory NoMethodsSpecified() = _NoMethodsSpecified;

  @Cached()
  Future<int> cachedMethod(int x) async {
    return 1;
  }

  @DeletesCache([])
  Future<void> deleteCache() async {}
}

@ShouldThrow(
  "[ERROR] invalidTarget is not a valid target for deleteCache",
  element: false,
)
@withCache
abstract class InvalidTarget {
  factory InvalidTarget() = _InvalidTarget;

  @Cached()
  Future<int> cachedMethod(int x) async {
    return 1;
  }

  Future<int> invalidTarget(int x) async {
    return 1;
  }

  @DeletesCache(['invalidTarget'])
  Future<void> deleteCache() async {}
}

@ShouldThrow(
  "[ERROR] `deleteCache` cant be an abstract method",
  element: false,
)
@withCache
abstract class CantBeAbstract {
  factory CantBeAbstract() = _CantBeAbstract;

  @Cached()
  Future<int> cachedMethod(int x) async {
    return 1;
  }

  @DeletesCache(['cachedMethod'])
  Future<void> deleteCache();
}

@ShouldGenerate(
  r'''
abstract class _$ValidNoTtl {}

class _ValidNoTtl with ValidNoTtl implements _$ValidNoTtl {
  _ValidNoTtl();

  final _getSthDataCached = <String, String?>{};

  @override
  Future<String?> getSthData(String id) async {
    final cachedValue = _getSthDataCached["${id.hashCode}"];
    if (cachedValue == null) {
      final String? toReturn;
      try {
        final result = super.getSthData(id);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getSthDataCached["${id.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> addToData(String value) async {
    final result = await super.addToData(value);

    _getSthDataCached.clear();

    return result;
  }
}
''',
)
@withCache
abstract class ValidNoTtl {
  factory ValidNoTtl() = _ValidNoTtl;

  @Cached()
  Future<String?> getSthData(String id) async {
    return '';
  }

  @DeletesCache(['getSthData'])
  Future<String> addToData(String value) async {
    return '';
  }
}

@ShouldGenerate(
  r'''
abstract class _$ValidTtl {}

class _ValidTtl with ValidTtl implements _$ValidTtl {
  _ValidTtl();

  final _getSthDataCached = <String, String?>{};

  final _getSthDataTtl = <String, DateTime>{};

  @override
  Future<String?> getSthData(String id) async {
    final now = DateTime.now();
    final currentTtl = _getSthDataTtl["${id.hashCode}"];

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getSthDataTtl.remove("${id.hashCode}");
      _getSthDataCached.remove("${id.hashCode}");
    }

    final cachedValue = _getSthDataCached["${id.hashCode}"];
    if (cachedValue == null) {
      final String? toReturn;
      try {
        final result = super.getSthData(id);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getSthDataCached["${id.hashCode}"] = toReturn;

      _getSthDataTtl["${id.hashCode}"] =
          DateTime.now().add(const Duration(seconds: 60));

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> addToData(String value) async {
    final result = await super.addToData(value);

    _getSthDataCached.clear();
    _getSthDataTtl.clear();

    return result;
  }
}
''',
)
@withCache
abstract class ValidTtl {
  factory ValidTtl() = _ValidTtl;

  @Cached(ttl: 60)
  Future<String?> getSthData(String id) async {
    return '';
  }

  @DeletesCache(['getSthData'])
  Future<String> addToData(String value) async {
    return '';
  }
}

@ShouldGenerate(
  r'''
abstract class _$ValidStreamed {}

class _ValidStreamed with ValidStreamed implements _$ValidStreamed {
  _ValidStreamed();

  final _getSthDataCached = <String, String?>{};

  static final _getSthDataCacheStreamController = StreamController<
      MapEntry<StreamEventIdentifier<_ValidStreamed>, String?>>.broadcast();

  @override
  Future<String?> getSthData(String id) async {
    final cachedValue = _getSthDataCached["${id.hashCode}"];
    if (cachedValue == null) {
      final String? toReturn;
      try {
        final result = super.getSthData(id);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getSthDataCached["${id.hashCode}"] = toReturn;

      _getSthDataCacheStreamController.sink.add(MapEntry(
        StreamEventIdentifier(
          instance: this,
          paramsKey: "${id.hashCode}",
        ),
        toReturn,
      ));

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Stream<String?> cachedStream(String id) async* {
    final paramsKey = "${id.hashCode}";
    final streamController = _getSthDataCacheStreamController;
    final stream = streamController.stream
        .where((event) => event.key.instance == this)
        .where((event) =>
            event.key.paramsKey == null || event.key.paramsKey == paramsKey)
        .map((event) => event.value);

    yield* stream;
  }

  @override
  Future<String> addToData(String value) async {
    final result = await super.addToData(value);

    _getSthDataCached.clear();
    _getSthDataCacheStreamController.sink.add(MapEntry(
      StreamEventIdentifier(
        instance: this,
      ),
      null,
    ));

    return result;
  }
}
''',
)
@withCache
abstract class ValidStreamed {
  factory ValidStreamed() = _ValidStreamed;

  @Cached()
  Future<String?> getSthData(String id) async {
    return '';
  }

  @StreamedCache(methodName: "getSthData")
  Stream<String?> cachedStream(String id);

  @DeletesCache(['getSthData'])
  Future<String> addToData(String value) async {
    return '';
  }
}

@ShouldGenerate(
  r'''
abstract class _$ValidTwoMethods {}

class _ValidTwoMethods with ValidTwoMethods implements _$ValidTwoMethods {
  _ValidTwoMethods();

  final _getSthDataCached = <String, String?>{};
  final _getSthDataNoTtlCached = <String, String>{};

  final _getSthDataTtl = <String, DateTime>{};

  @override
  Future<String?> getSthData(String id) async {
    final now = DateTime.now();
    final currentTtl = _getSthDataTtl["${id.hashCode}"];

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getSthDataTtl.remove("${id.hashCode}");
      _getSthDataCached.remove("${id.hashCode}");
    }

    final cachedValue = _getSthDataCached["${id.hashCode}"];
    if (cachedValue == null) {
      final String? toReturn;
      try {
        final result = super.getSthData(id);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getSthDataCached["${id.hashCode}"] = toReturn;

      _getSthDataTtl["${id.hashCode}"] =
          DateTime.now().add(const Duration(seconds: 60));

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> getSthDataNoTtl(String id) async {
    final cachedValue = _getSthDataNoTtlCached["${id.hashCode}"];
    if (cachedValue == null) {
      final String toReturn;
      try {
        final result = super.getSthDataNoTtl(id);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getSthDataNoTtlCached["${id.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> addToData(String value) async {
    final result = await super.addToData(value);

    _getSthDataCached.clear();
    _getSthDataNoTtlCached.clear();
    _getSthDataTtl.clear();

    return result;
  }
}
''',
)
@withCache
abstract class ValidTwoMethods {
  factory ValidTwoMethods() = ValidTwoMethods;

  @Cached(ttl: 60)
  Future<String?> getSthData(String id) async {
    return '';
  }

  @Cached()
  Future<String> getSthDataNoTtl(String id) {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => '',
    );
  }

  @DeletesCache(['getSthData', 'getSthDataNoTtl'])
  Future<String> addToData(String value) async {
    return '';
  }
}

@ShouldGenerate(
  r'''
abstract class _$ValidSync {}

class _ValidSync with ValidSync implements _$ValidSync {
  _ValidSync();

  final _getSthDataCached = <String, String>{};

  @override
  String getSthData(String id) {
    final cachedValue = _getSthDataCached["${id.hashCode}"];
    if (cachedValue == null) {
      final String toReturn;
      try {
        final result = super.getSthData(id);

        toReturn = result;
      } catch (_) {
        rethrow;
      } finally {}

      _getSthDataCached["${id.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  String addToData(String value) {
    final result = super.addToData(value);

    _getSthDataCached.clear();

    return result;
  }
}
''',
)
@withCache
abstract class ValidSync {
  factory ValidSync() = ValidSync;

  @Cached()
  String getSthData(String id) {
    return '';
  }

  @DeletesCache(['getSthData'])
  String addToData(String value) {
    return '';
  }
}