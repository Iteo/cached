import 'package:meta/meta_meta.dart';

const clearCached = ClearCached();

@Target({TargetKind.method})
class ClearCached {
  const ClearCached([this.methodName]);

  final String? methodName;
}
