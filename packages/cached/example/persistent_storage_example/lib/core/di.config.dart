// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjecteoConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:injecteo/injecteo.dart' as _i1;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

import '../data/repository.dart' as _i2;
import '../domain/bool_use_case.dart' as _i4;
import '../domain/delete_all_use_case.dart' as _i5;
import '../domain/delete_number_use_case.dart' as _i6;
import '../domain/delete_selected_use_case.dart' as _i7;
import '../domain/number_use_case.dart' as _i8;
import '../presentation/cubit/sample_cubit.dart' as _i9;
import 'di.dart' as _i10; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
///
/// configure registration of provided dependencies
Future<void> $injecteoConfig(
  _i1.ServiceLocator serviceLocator, {
  String? environment,
  _i1.EnvironmentFilter? environmentFilter,
}) async {
  await OtherInjectionModule().registerDependencies(
    serviceLocator,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}

class OtherInjectionModule extends _i1.BaseInjectionModule {
  @override
  Future<void> registerDependencies(
    _i1.ServiceLocator serviceLocator, {
    String? environment,
    _i1.EnvironmentFilter? environmentFilter,
  }) async {
    final serviceLocatorHelper = _i1.ServiceLocatorHelper(
      serviceLocator,
      environment,
      environmentFilter,
    );
    final storageModule = _$StorageModule();
    serviceLocatorHelper
        .registerFactory<_i2.Repository>(() => _i2.Repository());
    await serviceLocatorHelper.registerFactoryAsync<_i3.SharedPreferences>(
      () async => storageModule.prefs,
      preResolve: true,
    );
    serviceLocatorHelper.registerFactory<_i4.BoolUseCase>(
        () => _i4.BoolUseCase(serviceLocator.get<_i2.Repository>()));
    serviceLocatorHelper.registerFactory<_i5.DeleteAllUseCase>(
        () => _i5.DeleteAllUseCase(serviceLocator.get<_i2.Repository>()));
    serviceLocatorHelper.registerFactory<_i6.DeleteNumberUseCase>(
        () => _i6.DeleteNumberUseCase(serviceLocator.get<_i2.Repository>()));
    serviceLocatorHelper.registerFactory<_i7.DeleteSelectedUseCase>(
        () => _i7.DeleteSelectedUseCase(serviceLocator.get<_i2.Repository>()));
    serviceLocatorHelper.registerFactory<_i8.NumberUseCase>(
        () => _i8.NumberUseCase(serviceLocator.get<_i2.Repository>()));
    serviceLocatorHelper.registerFactory<_i9.SampleCubit>(() => _i9.SampleCubit(
          serviceLocator.get<_i8.NumberUseCase>(),
          serviceLocator.get<_i4.BoolUseCase>(),
          serviceLocator.get<_i6.DeleteNumberUseCase>(),
          serviceLocator.get<_i5.DeleteAllUseCase>(),
          serviceLocator.get<_i7.DeleteSelectedUseCase>(),
        ));
  }
}

class _$StorageModule extends _i10.StorageModule {}
