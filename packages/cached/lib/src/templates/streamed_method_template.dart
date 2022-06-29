import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class StreamedCacheMethodTemplate {
  StreamedCacheMethodTemplate(
    this.method, {
    required this.useStaticCache,
    required this.className,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final StreamedCacheMethod method;
  final bool useStaticCache;
  final String className;
  final AllParamsTemplate paramsTemplate;

  String generateStreamMap() {
    return 'static final ${getCacheStreamControllerName(method.targetMethodName)} = ${_streamMapInitializer()};';
  }

  String generateMethod() {
    return '''
@override
Stream<${method.coreReturnType}> ${method.name}(${paramsTemplate.generateParams()}) async* {
  final paramsKey = "${getParamKey(method.params)}";
  final streamController = ${getCacheStreamControllerName(method.targetMethodName)};
  final stream = streamController.stream
        ${_streamFilter()}
        .map((event) => event.value);
        
  ${_lastValueEmit()}
  
  yield* stream;
}
    ''';
  }

  String _lastValueEmit() {
    if (!method.emitLastValue) {
      return '';
    }

    return '''
      if(${getCacheMapName(method.targetMethodName)}.containsKey(paramsKey)) {
        final lastValue = ${getCacheMapName(method.targetMethodName)}[paramsKey];
        ${_yieldLastValue()}
      }
    ''';
  }

  String _yieldLastValue() {
    if (method.coreReturnTypeNullable) {
      return 'yield lastValue;';
    }

    return '''
      if(lastValue != null) {
        yield lastValue;
      }
    ''';
  }

  String _streamMapInitializer() => useStaticCache
      ? '''StreamController<MapEntry<String,${method.coreReturnType}>>.broadcast()'''
      : '''StreamController<MapEntry<StreamEventIdentifier<_$className>,${method.coreReturnType}>>.broadcast()''';

  String _streamFilter() => useStaticCache
      ? '''.where((event) => event.key == paramsKey)'''
      : '''
      .where((event) => event.key.instance == this)
      .where((event) => event.key.paramsKey == paramsKey)
        ''';
}
