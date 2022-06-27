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

  String _lastValueEmit() => method.emitLastValue
      ? _cacheContainsKeyCheck(
          '''
  final lastValue = ${getCacheMapName(method.targetMethodName)}[paramsKey];
  ${_lastValueEmitter('returnStreamController')}
      ''',
        )
      : '';

  String _lastValueEmitter(String streamControllerName) {
    return method.emitLastValue
        ? _lastValueNullCheck(
            !method.coreReturnTypeNullable,
            '''yield lastValue;''',
          )
        : '';
  }

  String _lastValueNullCheck(bool checkIfNull, String body) {
    return checkIfNull
        ? '''
    if(lastValue != null) {
      $body
    }'''
        : body;
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

  String _cacheContainsKeyCheck(String emitCode) =>
      method.coreReturnTypeNullable
          ? '''
      if(${getCacheMapName(method.targetMethodName)}.containsKey(paramsKey)) {
        $emitCode
      }
      '''
          : emitCode;
}
