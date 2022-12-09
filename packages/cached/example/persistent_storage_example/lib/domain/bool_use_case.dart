import 'package:injecteo/injecteo.dart';
import 'package:persistent_storage_example/data/repository.dart';

@inject
class BoolUseCase {
  BoolUseCase(this.repository);

  final Repository repository;

  Future<bool> call() async => repository.getBool();
}
