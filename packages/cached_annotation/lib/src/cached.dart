import 'package:meta/meta_meta.dart';

const cached = Cached();

@Target({TargetKind.method})
class Cached {
  const Cached({
    this.limit,
    this.syncWrite,
    this.ttl,
  });

  final int? limit;
  final int? ttl;
  final bool? syncWrite;
}
