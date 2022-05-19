// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_repository.dart';

// **************************************************************************
// CachedGenerator
// **************************************************************************

abstract class _$RemoteRepository {}

class _RemoteRepository with RemoteRepository implements _$RemoteRepository {
  _RemoteRepository();

  final _getSthDataCached = <String, SomeResponseType>{};

  @override
  Future<SomeResponseType> getSthData() async {
    final cachedValue = _getSthDataCached[""];
    if (cachedValue == null) {
      final SomeResponseType toReturn;
      try {
        final result = super.getSthData();

        toReturn = await result;
      } catch (_) {
        rethrow;
      } finally {}

      _getSthDataCached[""] = toReturn;

      return toReturn;
    }

    return cachedValue;
  }
}
