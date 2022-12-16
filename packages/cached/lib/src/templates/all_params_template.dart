import 'package:cached/src/models/param.dart';
import 'package:cached/src/templates/param_template.dart';
import 'package:source_gen/source_gen.dart';

class AllParamsTemplate {
  AllParamsTemplate(this.params);

  final Iterable<Param> params;

  String generateParams() {
    return _generateParams((param) => param.generateParam());
  }

  String generateThisParams() {
    return _generateParams((param) => param.generateThisParam());
  }

  String generateFields({bool addOverrideAnnotation = false}) {
    return params
        .map(ParamTemplate.new)
        .map((e) => e.generateField())
        .map((e) => '${addOverrideAnnotation ? "@override\n" : ''}$e')
        .join('\n');
  }

  String generateParamsUsage() {
    final positional = _positional();
    final named = _named();

    return [
      ...positional,
      ...named,
    ].join(',');
  }

  Iterable<String> _positional() {
    return params
        .where((e) => e.isPositional)
        .map(ParamTemplate.new)
        .map((e) => e.generateParameterUsage());
  }

  Iterable<String> _named() {
    return params
        .where((e) => e.isNamed)
        .map(ParamTemplate.new)
        .map((e) => e.generateParameterUsage());
  }

  String _generateParams(
    String Function(ParamTemplate) selector,
  ) {
    final paramTemplates = params.map(
      ParamTemplate.new,
    );
    final positionals = paramTemplates.where(
      (e) => e.param.isRequiredPositional,
    );
    final optionals = paramTemplates.where(
      (e) => e.param.isOptionalPositional,
    );
    final named = paramTemplates.where(
      (e) => e.param.isNamed,
    );

    final hasOptionals = optionals.isNotEmpty;
    final hasNamed = named.isNotEmpty;
    if (hasOptionals && hasNamed) {
      throw InvalidGenerationSourceError(
        "[ERROR] Method or constructor has optional positional params an named params which shouldn't be possible.",
      );
    }

    final positionalParams = positionals.map(selector).join(',');
    final optionalParams = _optionalParams(optionals, selector, hasOptionals);
    final namedParams = _namedParams(named, selector, hasNamed);

    return [positionalParams, optionalParams, namedParams]
        .whereType<String>()
        .where((element) => element.isNotEmpty)
        .join(',');
  }

  String? _optionalParams(
    Iterable<ParamTemplate> optionals,
    String Function(ParamTemplate) paramGeneratorSelector,
    bool hasOptionals,
  ) {
    final optionalParamsList = optionals.map(paramGeneratorSelector);
    final optionalParamsJoined = optionalParamsList.join(',');
    return hasOptionals ? '[$optionalParamsJoined]' : null;
  }

  String? _namedParams(
    Iterable<ParamTemplate> named,
    String Function(ParamTemplate) paramGeneratorSelector,
    bool hasNamed,
  ) {
    final namedParamsList = named.map(paramGeneratorSelector);
    final namedParamsJoined = namedParamsList.join(',');
    return hasNamed ? '{$namedParamsJoined}' : null;
  }
}
