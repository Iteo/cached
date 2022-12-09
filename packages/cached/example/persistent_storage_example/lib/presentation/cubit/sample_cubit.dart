import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecteo/injecteo.dart';
import 'package:persistent_storage_example/domain/bool_use_case.dart';
import 'package:persistent_storage_example/domain/delete_all_use_case.dart';
import 'package:persistent_storage_example/domain/delete_number_use_case.dart';
import 'package:persistent_storage_example/domain/delete_selected_use_case.dart';
import 'package:persistent_storage_example/domain/number_use_case.dart';
import 'package:persistent_storage_example/presentation/cubit/sample_cubit_state.dart';

@inject
@singleton
class SampleCubit extends Cubit<SampleCubitState> {
  SampleCubit(
    this._numberUseCase,
    this._boolUseCase,
    this._deleteNumberUseCase,
    this._deleteAllUseCase,
    this._deleteSelectedUseCase,
  ) : super(const SampleCubitNotInitialized());

  final NumberUseCase _numberUseCase;
  final BoolUseCase _boolUseCase;
  final DeleteNumberUseCase _deleteNumberUseCase;
  final DeleteAllUseCase _deleteAllUseCase;
  final DeleteSelectedUseCase _deleteSelectedUseCase;

  Future<void> updateDouble() async {
    final id = DateTime.now().microsecondsSinceEpoch;
    final number = await _numberUseCase();
    final logic = state.randomBool;
    final newState = SampleCubitInitialized(id, number, logic);

    emit(newState);
  }

  Future<void> updateBool() async {
    final id = DateTime.now().microsecondsSinceEpoch;
    final number = state.randomDouble;
    final logic = await _boolUseCase();
    final newState = SampleCubitInitialized(id, number, logic);

    emit(newState);
  }

  Future<void> deleteNumber() async {
    await _deleteNumberUseCase();
  }

  Future<void> deleteAll() async {
    await _deleteAllUseCase();
  }

  Future<void> deleteSelected() async {
    await _deleteSelectedUseCase();
  }
}
