import 'package:build/build.dart';
import 'package:cached/src/cached_generator.dart';
import 'package:cached/src/config.dart';
import 'package:source_gen/source_gen.dart';

///it's function used by build runner
Builder cachedBuilder(BuilderOptions options) {
  return PartBuilder(
    [
      CachedGenerator(
        config: Config.fromJson(options.config),
      ),
    ],
    '.cached.dart',
    header: '''
    // coverage:ignore-file
    // GENERATED CODE - DO NOT MODIFY BY HAND
    // ignore_for_file: type=lint
    ''',
  );
}
