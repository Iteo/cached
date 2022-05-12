import 'package:meta/meta_meta.dart';

const cached = Cashed();

@Target({TargetKind.method})
class Cashed {
  const Cashed({
    this.limit = 1,
    this.sync = false,
    this.ttl,
  });

  final int limit;
  final Duration? ttl;
  final bool sync;
}
