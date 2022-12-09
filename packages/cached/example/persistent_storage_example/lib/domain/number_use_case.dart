import 'package:injecteo/injecteo.dart';
import 'package:persistent_storage_example/data/repository.dart';

@inject
class NumberUseCase {
  NumberUseCase(this.repository);

  final Repository repository;

  Future<double> call() async => repository.getNumber();
}
