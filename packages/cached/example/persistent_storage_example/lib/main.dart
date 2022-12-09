import 'package:cached_annotation/cached_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:persistent_storage_example/core/di.dart';
import 'package:persistent_storage_example/data/storage/shared_preferences_storage.dart';
import 'package:persistent_storage_example/presentation/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies('dev');

  PersistentStorageHolder.storage = await SharedPreferencesStorage.instance();
  // PersistentStorageHolder.storage = await HiveStorage.create();
  // PersistentStorageHolder.storage = MockStorageImpl();

  final hookedBlocConfigProvider = HookedBlocConfigProvider(
    injector: () => serviceLocator.get,
    builderCondition: (state) => state != null, // Global build condition
    listenerCondition: (state) => state != null,
    child: const MyApp(),
  );

  runApp(hookedBlocConfigProvider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Persistent Storage Example';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: title),
    );
  }
}
