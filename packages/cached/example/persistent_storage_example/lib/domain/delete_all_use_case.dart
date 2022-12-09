import 'package:injecteo/injecteo.dart';
import 'package:persistent_storage_example/data/repository.dart';

@inject
class DeleteAllUseCase {
  DeleteAllUseCase(this.repository);

  final Repository repository;

  Future<void> call() async => repository.clearAll();
}
