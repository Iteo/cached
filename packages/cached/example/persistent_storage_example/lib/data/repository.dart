import 'dart:math';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:injecteo/injecteo.dart';

part 'repository.cached.dart';

@WithCache(useStaticCache: true)
@inject
abstract class Repository implements _$Repository {
  @factoryMethod
  factory Repository() = _Repository;

  final _generator = Random();

  @Cached(
    syncWrite: false,
    persistentStorage: true,
    ttl: 30,
  )
  Future<double> getNumber() async {
    await _delay();
    return _generator.nextDouble() * 257;
  }

  @Cached(
    syncWrite: true,
    persistentStorage: true,
    ttl: 60,
  )
  Future<bool> getBool() async {
    await _delay();
    return _generator.nextBool();
  }

  @Cached(persistentStorage: true)
  Future<String> getText() async {
    await _delay();
    return 'Lorem ipsum.';
  }

  @clearAllCached
  Future<void> clearAll() async {}

  @ClearCached('getNumber')
  Future<void> clearGetNumber() async {}

  @DeletesCache(['getNumber', 'getText'])
  Future<void> deleteSelected() async {}

  Future<void> _delay() async {
    const duration = Duration(seconds: 1);
    await Future<void>.delayed(duration);
  }
}
