import 'package:meta/meta_meta.dart';

@Target({TargetKind.method})
class ClearCached {
  const ClearCached(this.methodName);

  final String methodName;
}
