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
    final params = paramsTemplate.generateParams();
    final paramKey = getParamKey(method.params);
    final cacheStreamControllerName = getCacheStreamControllerName(
      method.targetMethodName,
    );

    return '''
       @override
       Stream<${method.coreReturnType}> ${method.name}($params) async* {
          final paramsKey = "$paramKey";
          final streamController = $cacheStreamControllerName;
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

    final cacheMapName = getCacheMapName(method.targetMethodName);
    return '''
      if($cacheMapName.containsKey(paramsKey)) {
        final lastValue = $cacheMapName[paramsKey];
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

  String _streamMapInitializer() =>
      '''StreamController<MapEntry<StreamEventIdentifier<_$className>,${method.coreReturnType}>>.broadcast()''';

  String _streamFilter() {
    const eventFilter = '.where((event) => event.key.instance == this)';
    final text = useStaticCache ? '' : eventFilter;

    return '''
      $text
      .where((event) => event.key.paramsKey == null || event.key.paramsKey == paramsKey)
    ''';
  }
}
