import 'package:meta/meta_meta.dart';

const withCache = WithCache();

@Target({TargetKind.classType})
class WithCache {
  const WithCache({
    this.useStaticCache,
  });

  final bool? useStaticCache;
}
