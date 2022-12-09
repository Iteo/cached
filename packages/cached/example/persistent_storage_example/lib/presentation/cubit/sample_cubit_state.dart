import 'package:equatable/equatable.dart';

abstract class SampleCubitState extends Equatable {
  const SampleCubitState(this.id, this.randomDouble, this.randomBool);

  final int id;
  final double randomDouble;
  final bool randomBool;

  @override
  List<Object?> get props => [id, randomDouble, randomBool];

  @override
  String toString() => 'ID: $id\n'
      'Random double: $randomDouble\n'
      'Random bool: $randomBool';
}

class SampleCubitNotInitialized extends SampleCubitState {
  const SampleCubitNotInitialized() : super(-1, -1, false);
}

class SampleCubitInitialized extends SampleCubitState {
  const SampleCubitInitialized(
    super.id,
    super.randomDouble,
    super.randomBool,
  );
}
