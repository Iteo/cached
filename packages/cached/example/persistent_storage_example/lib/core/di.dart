import 'package:injecteo/injecteo.dart';
import 'package:persistent_storage_example/core/di.config.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetItServiceLocator.instance;

@injecteoConfig
Future<void> configureDependencies(String env) async => $injecteoConfig(
      serviceLocator,
      environment: env,
    );

@externalModule
abstract class StorageModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
