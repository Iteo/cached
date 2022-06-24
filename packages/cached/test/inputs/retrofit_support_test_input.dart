import 'package:cached_annotation/cached_annotation.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:source_gen_test/source_gen_test.dart';

@ShouldGenerate(r'''
abstract class _$SimpleRetrofit {
  Dio get dio;
}

class _CachedSimpleRetrofit extends _SimpleRetrofit
    implements _$SimpleRetrofit {
  _CachedSimpleRetrofit(this.dio) : super(dio);

  @override
  final Dio dio;

  final _testCached = <String, int>{};

  @override
  Future<int> test() async {
    final cachedValue = _testCached[""];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.test();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _testCached[""] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
@RestApi("")
abstract class SimpleRetrofit {
  factory SimpleRetrofit(Dio dio) = _CachedSimpleRetrofit;

  @cached
  @GET("/test")
  Future<int> test();
}

@ShouldGenerate(r'''
abstract class _$SimpleParameters {
  Dio get dio;
}

class _CachedSimpleParameters extends _SimpleParameters
    implements _$SimpleParameters {
  _CachedSimpleParameters(this.dio) : super(dio);

  @override
  final Dio dio;

  final _testCached = <String, int>{};

  @override
  Future<int> test(int x, int y) async {
    final cachedValue = _testCached["${x.hashCode}${y.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.test(x, y);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _testCached["${x.hashCode}${y.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
@RestApi("")
abstract class SimpleParameters {
  factory SimpleParameters(Dio dio) = _SimpleParameters;

  @cached
  @GET("/test/{x}/{y}")
  Future<int> test(@Path() int x, @Path() int y);
}

@ShouldGenerate(r'''
abstract class _$RetrofitWithCacheKey {
  Dio get dio;
}

class _CachedRetrofitWithCacheKey extends _RetrofitWithCacheKey
    implements _$RetrofitWithCacheKey {
  _CachedRetrofitWithCacheKey(this.dio) : super(dio);

  @override
  final Dio dio;

  final _testCached = <String, int>{};

  @override
  Future<int> test(int x, List<int> y) async {
    final cachedValue = _testCached["${x.hashCode}${_cacheKey(y)}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.test(x, y);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _testCached["${x.hashCode}${_cacheKey(y)}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
@RestApi("")
abstract class RetrofitWithCacheKey {
  factory RetrofitWithCacheKey(Dio dio) = _RetrofitWithCacheKey;

  @cached
  @GET("/test/{x}/{y}")
  Future<int> test(
    @Path() int x,
    @CacheKey(cacheKeyGenerator: _cacheKey) @Path() List<int> y,
  );
}

@ShouldGenerate(r'''
abstract class _$IgnoredParameter {
  Dio get dio;
}

class _CachedIgnoredParameter extends _IgnoredParameter
    implements _$IgnoredParameter {
  _CachedIgnoredParameter(this.dio) : super(dio);

  @override
  final Dio dio;

  final _testCached = <String, int>{};

  @override
  Future<int> test(String z, int x) async {
    final cachedValue = _testCached["${x.hashCode}"];
    if (cachedValue == null) {
      final int toReturn;
      try {
        final result = super.test(z, x);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _testCached["${x.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
@RestApi("")
abstract class IgnoredParameter {
  factory IgnoredParameter(Dio dio) = _IgnoredParameter;

  @cached
  @GET("/test/{z}/{y}")
  Future<int> test(
    @ignore @Path() String z,
    @Path() int x,
  );
}

@ShouldGenerate(r'''
abstract class _$IgnoreCache {
  Dio get dio;
}

class _CachedIgnoreCache extends _IgnoreCache implements _$IgnoreCache {
  _CachedIgnoreCache(this.dio) : super(dio);

  @override
  final Dio dio;

  final _testCached = <String, int>{};

  @override
  Future<int> test(String z, bool ignoreCache) async {
    final cachedValue = _testCached["${z.hashCode}"];
    if (cachedValue == null || ignoreCache) {
      final int toReturn;
      try {
        final result = super.test(z, ignoreCache);

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _testCached["${z.hashCode}"] = toReturn;

      return toReturn;
    } else {
      return cachedValue;
    }
  }
}
''')
@withCache
@RestApi("")
abstract class IgnoreCache {
  factory IgnoreCache(Dio dio) = _IgnoreCache;

  @cached
  @GET("/test/{z}")
  Future<int> test(
    @Path() String z,
    @ignoreCache bool ignoreCache,
  );
}

String _cacheKey(dynamic value) => value.hashCode;
