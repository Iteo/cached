import 'package:cached/src/models/param.dart';

class ParamTemplate {
  const ParamTemplate(this.param);

  final Param param;

  String get _requiredKeyword => param.isRequiredNamed ? 'required' : '';

  String get _defaultValue =>
      param.defaultValue != null ? '= ${param.defaultValue}' : '';

  String generateParam() {
    return '$_requiredKeyword ${param.type} ${param.name} $_defaultValue';
  }

  String generateThisParam() {
    return '$_requiredKeyword this.${param.name} $_defaultValue';
  }

  String generateField() {
    return 'final ${param.type} ${param.name};';
  }

  String generateParameterUsage() {
    if (param.isNamed) {
      return '${param.name}: ${param.name}';
    } else {
      return param.name;
    }
  }
}
