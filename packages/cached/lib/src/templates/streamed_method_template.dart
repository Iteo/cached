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
    return '${_getStaticModifier()} final ${getCacheStreamMapName(method.targetMethodName)} = <String, StreamController<${method.coreReturnType}>>{};';
  }

  String generateMethod() {
    return '''
@override
Stream<${method.coreReturnType}> ${method.name}(${paramsTemplate.generateParams()}) {
  final paramsKey = "${getParamKey(method.params)}";
  final streamController = ${getCacheStreamMapName(method.targetMethodName)}[paramsKey];
  ${_lastValueRead()}

  if(streamController == null) {
    final newStreamController = StreamController<${method.coreReturnType}>.broadcast();
    ${getCacheStreamMapName(method.targetMethodName)}[paramsKey] = newStreamController;
    
    final returnStream = StreamController<${method.coreReturnType}>();
    ${_lastValueEmitter("returnStream")}
    returnStream.sink.addStream(newStreamController.stream);
    
    return returnStream.stream;
  } else {
    final returnStream = StreamController<${method.coreReturnType}>();
    ${_lastValueEmitter("returnStream")}
    returnStream.sink.addStream(streamController.stream);
     
    return returnStream.stream;
  }
}
    ''';
  }

  String _getStaticModifier() {
    return useStaticCache ? 'static' : '';
  }

  String _lastValueRead() {
    return method.emitLastValue
        ? '''final lastValue = ${getCacheMapName(method.targetMethodName)}[paramsKey];'''
        : '';
  }

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
    }       
        '''
        : body;
  }
}
