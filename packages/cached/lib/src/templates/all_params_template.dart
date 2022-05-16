import 'package:cached/src/models/param.dart';
import 'package:cached/src/templates/param_template.dart';
import 'package:source_gen/source_gen.dart';

class AllParamsTemplate {
  final Iterable<Param> params;

  AllParamsTemplate(this.params);

  String generateParams() {
    return _generateParams((param) => param.generateParam());
  }

  String generateThisParams() {
    return _generateParams((param) => param.generateThisParam());
  }

  String generateFields({bool addOverrideAnnotation = false}) {
    return params
        .map((e) => ParamTemplate(e))
        .map((e) => e.generateField())
        .map((e) => '${addOverrideAnnotation ? "@override\n" : ''}$e')
        .join('\n');
  }

  String generateParamsUsage() {
    final positional = params
        .where((e) => e.isPositional)
        .map((e) => ParamTemplate(e))
        .map((e) => e.generateParameterUsage());
    final named = params
        .where((e) => e.isNamed)
        .map((e) => ParamTemplate(e))
        .map((e) => e.generateParameterUsage());

    return [...positional, ...named].join(',');
  }

  String _generateParams(
    String Function(ParamTemplate) paramGeneratorSelector,
  ) {
    final paramTemeplates = params.map((e) => ParamTemplate(e));
    final positional =
        paramTemeplates.where((e) => e.param.isRequiredPositional);
    final optional = paramTemeplates.where((e) => e.param.isOptionalPositional);
    final named = paramTemeplates.where((e) => e.param.isNamed);

    if (optional.isNotEmpty && named.isNotEmpty) {
      throw InvalidGenerationSourceError(
        'Method or constructor has oprional positional params an named params which shouldnt be possible.',
      );
    }

    final positionalParams = positional.map(paramGeneratorSelector).join(',');
    final optionalParams = optional.isNotEmpty
        ? '[${optional.map(paramGeneratorSelector).join(',')}]'
        : null;
    final namedParams = named.isNotEmpty
        ? '{${named.map(paramGeneratorSelector).join(',')}}'
        : null;

    return [positionalParams, optionalParams, namedParams]
        .whereType<String>()
        .join(',');
  }
}
