import 'package:meta/meta_meta.dart';

const ignoreCache = IgnoreCache();

@Target({TargetKind.parameter})
class IgnoreCache {
  const IgnoreCache({
    this.useCacheOnError,
  });

  final bool? useCacheOnError;
}
