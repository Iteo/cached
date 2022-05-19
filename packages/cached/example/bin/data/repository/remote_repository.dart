import 'package:cached_annotation/cached_annotation.dart';
import '../../domain/repository/repository.dart';

part 'remote_repository.cached.dart';

@WithCache()
abstract class RemoteRepository implements Repository, _$RemoteRepository {
  factory RemoteRepository() = _RemoteRepository;

  @override
  @Cached()
  Future<SomeResponseType> getSthData() {
    return Future.value(SomeResponseType());
  }
}
