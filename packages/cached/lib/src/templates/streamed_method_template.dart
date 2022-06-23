import 'package:cached/src/models/streamed_cache_method.dart';
import 'package:cached/src/templates/all_params_template.dart';
import 'package:cached/src/utils/utils.dart';

class StreamedCacheMethodTemplate {
  StreamedCacheMethodTemplate(
    this.method, {
    required this.useStaticCache,
  }) : paramsTemplate = AllParamsTemplate(method.params);

  final StreamedCacheMethod method;
  final bool useStaticCache;
  final AllParamsTemplate paramsTemplate;

  String generateStreamMap() {
    return '${_getStaticModifier()} final ${getCacheStreamControllerName(method.targetMethodName)} = ${_streamMapInitializer()};';
  }

  String generateMethod() {
    return '''
@override
Stream<${method.coreReturnType}> ${method.name}(${paramsTemplate.generateParams()}) {
  final paramsKey = "${getParamKey(method.params)}";
  final streamController = ${getCacheStreamControllerName(method.targetMethodName)};
  final stream = streamController${_controllerBeforeFilterCall()}
        .where((event) => event.key == paramsKey)
        .map((event) => event.value);
        
  ${_streamReturn()}
}
    ''';
  }

  String _getStaticModifier() {
    return useStaticCache ? 'static' : '';
  }

  String _streamReturn() => method.emitLastValue
      ? '''
  final returnStreamController = StreamController<int>();
  final lastValue = _cachedTimestampCached[paramsKey];
  ${_lastValueEmitter('returnStreamController')}
  returnStreamController.addStream(stream);
 
  return returnStreamController.stream;
      '''
      : '''return stream;''';

  String _lastValueEmitter(String streamControllerName) {
    return method.emitLastValue
        ? _lastValueNullCheck(
            !method.coreReturnTypeNullable,
            '''$streamControllerName.sink.add(lastValue);''',
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

  String _streamMapInitializer() => method.useBehaviorSubject
      ? '''BehaviorSubject<MapEntry<String,${method.coreReturnType}>>()'''
      : '''StreamController<MapEntry<String,${method.coreReturnType}>>.broadcast()''';

  String _controllerBeforeFilterCall() =>
      method.useBehaviorSubject ? '' : '.stream';
}
