import 'package:cached/src/models/cache_peek_method.dart';
import 'package:cached/src/models/cached_getter.dart';
import 'package:cached/src/models/cached_method.dart';
import 'package:cached/src/models/class_with_cache.dart';
import 'package:cached/src/models/clear_cached_method.dart';
import 'package:cached/src/models/deletes_cache_method.dart';
import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/templates/cache_peek_method_template.dart';
import 'package:cached/src/templates/cached_getter_template.dart';
import 'package:cached/src/templates/cached_method_with_params_template.dart';
import 'package:cached/src/templates/clear_all_cached_method_template.dart';
import 'package:cached/src/templates/clear_cached_method_template.dart';
import 'package:cached/src/templates/deletes_cache_method_template.dart';
import 'package:cached/src/templates/streamed_method_template.dart';
import 'package:collection/collection.dart';

class ClassTemplate {
  ClassTemplate(this.classWithCache);

  final ClassWithCache classWithCache;
  bool _isPersisted = false;

  String generate() {
    final classMethods = classWithCache.methods;

    final methodTemplates = _getMethodTemplates(classMethods);
    _isPersisted = methodTemplates.any(_hasPersistentStorage);

    final getterTemplates = _getGetterTemplates();

    final streamedCacheMethodTemplates = _getStreamedCacheMethodTemplates();

    final clearMethodTemplates = _getClearMethodTemplates();
    final clearAllMethodTemplate = _getClearAllMethodTemplates(classMethods);

    final cachePeekMethodTemplates = _getCachePeekMethodTemplates();
    final constructorParamTemplates = _getConstructorParamTemplates();

    final deletesCacheMethodTemplates = _getDeleterCacheMethodTemplates();

    return '''
       class _${classWithCache.name} with ${classWithCache.name} implements _\$${classWithCache.name} {
         _${classWithCache.name}(${constructorParamTemplates.generateThisParams()})${_initAsyncStorage(methodTemplates)}

         ${constructorParamTemplates.generateFields(addOverrideAnnotation: true)}
         ${_generateCompleterFields(methodTemplates)}
         ${_generateStaticLock(methodTemplates)}

         ${methodTemplates.map((e) => e.generateSyncMap()).join('\n')}
         ${getterTemplates.map((e) => e.generateSyncMap()).join('\n')}

         ${methodTemplates.map((e) => e.generateCacheMap()).join('\n')}
         ${getterTemplates.map((e) => e.generateCacheMap()).join('\n')}

         ${methodTemplates.map((e) => e.generateTtlMap()).join('\n')}
         ${getterTemplates.map((e) => e.generateTtlMap()).join('\n')}

         ${streamedCacheMethodTemplates.map((e) => e.generateStreamMap()).join('\n')}

         ${methodTemplates.map((e) => e.generate()).join('\n\n')}
         ${getterTemplates.map((e) => e.generate()).join('\n\n')}

         ${streamedCacheMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}

         ${clearMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}

         ${cachePeekMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}

         ${clearAllMethodTemplate.generateMethod()}

         ${deletesCacheMethodTemplates.map((e) => e.generateMethod()).join('\n\n')}
       }
       ''';
  }

  String _initAsyncStorage(
    Iterable<CachedMethodWithParamsTemplate> methodTemplates,
  ) {
    if (_isPersisted) {
      return '''
         { _init(); }
              
         Future<void> _init() async {
            ${_generateStaticReturn(methodTemplates)}   
                    
            ${methodTemplates.map((e) => e.generateAsyncPersistentStorageInit()).join('\n')}
            _completer.complete();            
         }
     ''';
    }

    return ';';
  }

  String _generateCompleterFields(
    Iterable<CachedMethodWithParamsTemplate> methodTemplates,
  ) {
    if (_isPersisted) {
      return '''
         final _completer = Completer<void>();
         Future<void> get _completerFuture => _completer.future;         
      ''';
    }

    return '';
  }

  bool _hasPersistentStorage(CachedMethodWithParamsTemplate element) {
    final function = element.function;
    final method = element.method;

    final hasPersistentFunction = method.persistentStorage == true;
    final hasPersistentMethod = function.persistentStorage == true;

    return hasPersistentFunction || hasPersistentMethod;
  }

  String _generateStaticLock(
    Iterable<CachedMethodWithParamsTemplate> templates,
  ) {
    final isStatic = classWithCache.useStaticCache;
    if (_isPersisted && isStatic) {
      return 'static bool _isStaticCacheLocked = false;';
    }

    return '';
  }

  String _generateStaticReturn(
    Iterable<CachedMethodWithParamsTemplate> methodTemplates,
  ) {
    final isStatic = classWithCache.useStaticCache;
    if (_isPersisted && isStatic) {
      return '''
         if (_isStaticCacheLocked == true) {
            return _completer.complete();
         } else {
            _isStaticCacheLocked = true;
         }
      ''';
    }

    return '';
  }

  Iterable<CachedMethodWithParamsTemplate> _getMethodTemplates(
    Iterable<CachedMethod> classMethods,
  ) {
    return classMethods.map(_classMethodsMapper);
  }

  CachedMethodWithParamsTemplate _classMethodsMapper(CachedMethod method) {
    final useStaticCache = classWithCache.useStaticCache;
    final streamedCacheMethods = classWithCache.streamedCacheMethods;
    final isCacheStreamed = streamedCacheMethods.any(
        (s) => s.targetMethodName == method.name,
      );

    return CachedMethodWithParamsTemplate(
      method,
      useStaticCache: useStaticCache,
      isCacheStreamed: isCacheStreamed,
    );
  }

  Iterable<CachedGetterTemplate> _getGetterTemplates() {
    final getters = classWithCache.getters;
    return getters.map(
      _gettersMapper,
    );
  }

  CachedGetterTemplate _gettersMapper(CachedGetter getter) {
    final useStaticCache = classWithCache.useStaticCache;
    final streamedCacheMethods = classWithCache.streamedCacheMethods;
    final isCacheStreamed = streamedCacheMethods.any(
        (s) => s.targetMethodName == getter.name,
      );

    return CachedGetterTemplate(
      getter,
      useStaticCache: useStaticCache,
      isCacheStreamed: isCacheStreamed,
    );
  }

  Iterable<StreamedCacheMethodTemplate> _getStreamedCacheMethodTemplates() {
    final streamedCacheMethods = classWithCache.streamedCacheMethods;
    return streamedCacheMethods.map(_streamedCacheMethodsMapper);
  }

  StreamedCacheMethodTemplate _streamedCacheMethodsMapper(
    StreamedCacheMethod method,
  ) {
    final useStaticCache = classWithCache.useStaticCache;
    final name = classWithCache.name;

    return StreamedCacheMethodTemplate(
      method,
      useStaticCache: useStaticCache,
      className: name,
    );
  }

  Iterable<ClearCachedMethodTemplate> _getClearMethodTemplates() {
    final clearMethods = classWithCache.clearMethods;
    return clearMethods.map(_clearMethodsMapper);
  }

  ClearCachedMethodTemplate _clearMethodsMapper(ClearCachedMethod method) {
    final streamedCacheMethods = classWithCache.streamedCacheMethods;
    final streamedCacheMethod = streamedCacheMethods.firstWhereOrNull(
      (m) => m.targetMethodName == method.name,
    );

    return ClearCachedMethodTemplate(
      method,
      streamedCacheMethod: streamedCacheMethod,
      isPersisted: _isPersisted,
    );
  }

  ClearAllCachedMethodTemplate _getClearAllMethodTemplates(
    Iterable<CachedMethod> classMethods,
  ) {
    final streamedCacheMethods = classWithCache.streamedCacheMethods;
    final getters = classWithCache.getters;
    final clearAllMethod = classWithCache.clearAllMethod;

    return ClearAllCachedMethodTemplate(
      method: clearAllMethod,
      cachedMethods: classMethods,
      cachedGetters: getters,
      streamedCacheMethods: streamedCacheMethods,
      isPersisted: _isPersisted,
    );
  }

  Iterable<CachePeekMethodTemplate> _getCachePeekMethodTemplates() {
    final cachePeekMethods = classWithCache.cachePeekMethods;
    return cachePeekMethods.map(_cachePeekMethodsMapper);
  }

  CachePeekMethodTemplate _cachePeekMethodsMapper(CachePeekMethod method) {
    final name = classWithCache.name;
    return CachePeekMethodTemplate(method, className: name);
  }

  AllParamsTemplate _getConstructorParamTemplates() {
    final constructor = classWithCache.constructor;
    final params = constructor.params;

    return AllParamsTemplate(params);
  }

  Iterable<DeletesCacheMethodTemplate> _getDeleterCacheMethodTemplates() {
    final deletesCacheMethods = classWithCache.deletesCacheMethods;
    return deletesCacheMethods.map(_deletesCacheMethodTemplate);
  }

  DeletesCacheMethodTemplate _deletesCacheMethodTemplate(
    DeletesCacheMethod method,
  ) {
    final streamedCacheMethods = classWithCache.streamedCacheMethods;
    final methods = _filteredStreamedCacheMethods(streamedCacheMethods, method);

    return DeletesCacheMethodTemplate(
      method,
      methods,
      isPersisted: _isPersisted,
    );
  }

  List<StreamedCacheMethod> _filteredStreamedCacheMethods(
    Iterable<StreamedCacheMethod> streamedCacheMethods,
    DeletesCacheMethod method,
  ) {
    return streamedCacheMethods
        .where(
          (streamedMethod) => _streamedMethodFilter(method, streamedMethod),
        )
        .toList();
  }

  bool _streamedMethodFilter(
    DeletesCacheMethod method,
    StreamedCacheMethod streamedMethod,
  ) {
    final methodNames = method.methodNames;
    final targetMethodName = streamedMethod.targetMethodName;

    return methodNames.contains(targetMethodName);
  }
}
