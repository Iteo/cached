import 'package:cached_annotation/cached_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldGenerate(
  r'''
abstract class _$StaticPersistedRepository {}

class _StaticPersistedRepository
    with StaticPersistedRepository
    implements _$StaticPersistedRepository {
  _StaticPersistedRepository() {
    _init();
  }

  Future<void> _init() async {
    if (_isStaticCacheLocked == true) {
      return _completer.complete();
    } else {
      _isStaticCacheLocked = true;
    }

    try {
      _getNumberCached = await PersistentStorageHolder.read('_getNumberCached');
    } catch (e) {
      _getNumberCached = <String, dynamic>{};
    }

    try {
      _getNumberTtl = await PersistentStorageHolder.read('_getNumberTtl');
    } catch (e) {
      _getNumberTtl = <String, dynamic>{};
    }

    try {
      _getBoolCached = await PersistentStorageHolder.read('_getBoolCached');
    } catch (e) {
      _getBoolCached = <String, dynamic>{};
    }

    try {
      _getBoolTtl = await PersistentStorageHolder.read('_getBoolTtl');
    } catch (e) {
      _getBoolTtl = <String, dynamic>{};
    }

    try {
      _getTextCached = await PersistentStorageHolder.read('_getTextCached');
    } catch (e) {
      _getTextCached = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  static bool _isStaticCacheLocked = false;

  static final _getBoolSync = <String, Future<bool>>{};

  static late final _getNumberCached;
  static late final _getBoolCached;
  static late final _getTextCached;

  static late final _getNumberTtl;
  static late final _getBoolTtl;

  @override
  Future<double> getNumber() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getNumberTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getNumberTtl.remove("");
      _getNumberCached.remove("");
    }

    final cachedValue = _getNumberCached[""];
    if (cachedValue == null) {
      final double toReturn;
      try {
        final result = super.getNumber();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getNumberCached[""] = toReturn;

      const duration = Duration(seconds: 30);
      _getNumberTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getNumberCached', _getNumberCached);
      await PersistentStorageHolder.write('_getNumberTtl', _getNumberTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<bool> getBool() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getBoolTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getBoolTtl.remove("");
      _getBoolCached.remove("");
    }

    final cachedValue = _getBoolCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getBoolSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final bool toReturn;
      try {
        final result = super.getBool();
        _getBoolSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getBoolSync.remove('');
      }

      _getBoolCached[""] = toReturn;

      const duration = Duration(seconds: 60);
      _getBoolTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getBoolCached', _getBoolCached);
      await PersistentStorageHolder.write('_getBoolTtl', _getBoolTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> getText() async {
    await _completerFuture;

    final cachedValue = _getTextCached[""];
    if (cachedValue == null) {
      final String toReturn;
      try {
        final result = super.getText();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getTextCached[""] = toReturn;

      await PersistentStorageHolder.write('_getTextCached', _getTextCached);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<void> clearGetNumber() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearGetNumber();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
    }
  }

  @override
  Future<void> clearAll() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearAll();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    _getBoolCached.clear();
    _getBoolTtl.clear();

    _getTextCached.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.deleteAll();
    }
  }

  @override
  Future<void> deleteSelected() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    final result = await super.deleteSelected();

    _getNumberCached.clear();
    _getTextCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
      await PersistentStorageHolder.delete('_getTextCached');
    }

    return result;
  }
}
''',
)
@WithCache(useStaticCache: true)
abstract class StaticPersistedRepository {
  factory PersistedRepository() = _PersistedRepository;

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
    await Future.delayed(duration);
  }
}

@ShouldGenerate(
  r'''
abstract class _$NonStaticPersistedRepository {}

class _NonStaticPersistedRepository
    with NonStaticPersistedRepository
    implements _$NonStaticPersistedRepository {
  _NonStaticPersistedRepository() {
    _init();
  }

  Future<void> _init() async {
    try {
      _getNumberCached = await PersistentStorageHolder.read('_getNumberCached');
    } catch (e) {
      _getNumberCached = <String, dynamic>{};
    }

    try {
      _getNumberTtl = await PersistentStorageHolder.read('_getNumberTtl');
    } catch (e) {
      _getNumberTtl = <String, dynamic>{};
    }

    try {
      _getBoolCached = await PersistentStorageHolder.read('_getBoolCached');
    } catch (e) {
      _getBoolCached = <String, dynamic>{};
    }

    try {
      _getBoolTtl = await PersistentStorageHolder.read('_getBoolTtl');
    } catch (e) {
      _getBoolTtl = <String, dynamic>{};
    }

    try {
      _getTextCached = await PersistentStorageHolder.read('_getTextCached');
    } catch (e) {
      _getTextCached = <String, dynamic>{};
    }

    _completer.complete();
  }

  final _completer = Completer<void>();
  Future<void> get _completerFuture => _completer.future;

  final _getBoolSync = <String, Future<bool>>{};

  late final _getNumberCached;
  late final _getBoolCached;
  late final _getTextCached;

  late final _getNumberTtl;
  late final _getBoolTtl;

  @override
  Future<double> getNumber() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getNumberTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getNumberTtl.remove("");
      _getNumberCached.remove("");
    }

    final cachedValue = _getNumberCached[""];
    if (cachedValue == null) {
      final double toReturn;
      try {
        final result = super.getNumber();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getNumberCached[""] = toReturn;

      const duration = Duration(seconds: 30);
      _getNumberTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getNumberCached', _getNumberCached);
      await PersistentStorageHolder.write('_getNumberTtl', _getNumberTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<bool> getBool() async {
    await _completerFuture;

    final now = DateTime.now();
    final cachedTtl = _getBoolTtl[""];
    final currentTtl = cachedTtl != null ? DateTime.parse(cachedTtl) : null;

    if (currentTtl != null && currentTtl.isBefore(now)) {
      _getBoolTtl.remove("");
      _getBoolCached.remove("");
    }

    final cachedValue = _getBoolCached[""];
    if (cachedValue == null) {
      final cachedFuture = _getBoolSync[""];

      if (cachedFuture != null) {
        return cachedFuture;
      }

      final bool toReturn;
      try {
        final result = super.getBool();
        _getBoolSync[""] = result;
        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {
        _getBoolSync.remove('');
      }

      _getBoolCached[""] = toReturn;

      const duration = Duration(seconds: 60);
      _getBoolTtl[""] = DateTime.now().add(duration).toIso8601String();

      await PersistentStorageHolder.write('_getBoolCached', _getBoolCached);
      await PersistentStorageHolder.write('_getBoolTtl', _getBoolTtl);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<String> getText() async {
    await _completerFuture;

    final cachedValue = _getTextCached[""];
    if (cachedValue == null) {
      final String toReturn;
      try {
        final result = super.getText();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getTextCached[""] = toReturn;

      await PersistentStorageHolder.write('_getTextCached', _getTextCached);

      return toReturn;
    } else {
      return cachedValue;
    }
  }

  @override
  Future<void> clearGetNumber() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearGetNumber();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
    }
  }

  @override
  Future<void> clearAll() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    await super.clearAll();

    _getNumberCached.clear();
    _getNumberTtl.clear();

    _getBoolCached.clear();
    _getBoolTtl.clear();

    _getTextCached.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.deleteAll();
    }
  }

  @override
  Future<void> deleteSelected() async {
    if (PersistentStorageHolder.isStorageSet) {
      await _completerFuture;
    }

    final result = await super.deleteSelected();

    _getNumberCached.clear();
    _getTextCached.clear();
    _getNumberTtl.clear();

    if (PersistentStorageHolder.isStorageSet) {
      await PersistentStorageHolder.delete('_getNumberCached');
      await PersistentStorageHolder.delete('_getTextCached');
    }

    return result;
  }
}
''',
)
@withCache
abstract class NonStaticPersistedRepository {
  factory PersistedRepository() = _PersistedRepository;

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
    await Future.delayed(duration);
  }
}
