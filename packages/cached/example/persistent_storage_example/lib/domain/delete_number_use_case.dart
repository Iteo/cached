import 'package:injecteo/injecteo.dart';
import 'package:persistent_storage_example/data/repository.dart';

@inject
class DeleteNumberUseCase {
  DeleteNumberUseCase(this.repository);

  final Repository repository;

  Future<void> call() async => repository.clearGetNumber();
}
