import 'package:injecteo/injecteo.dart';
import 'package:persistent_storage_example/data/repository.dart';

@inject
class DeleteSelectedUseCase {
  DeleteSelectedUseCase(this.repository);

  final Repository repository;

  Future<void> call() async => repository.deleteSelected();
}
