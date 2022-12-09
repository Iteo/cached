import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:persistent_storage_example/presentation/cubit/sample_cubit.dart';
import 'package:persistent_storage_example/presentation/widget/buttons_grid.dart';
import 'package:persistent_storage_example/presentation/widget/counter_display.dart';

class MyHomePage extends HookWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<SampleCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: PageBody(cubit: cubit),
      ),
    );
  }
}

class PageBody extends HookWidget {
  const PageBody({
    required this.cubit,
    super.key,
  });

  final SampleCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    return Center(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: CounterDisplay(
              randomBool: state.randomBool,
              randomDouble: state.randomDouble,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: ButtonsGrid(cubit: cubit),
          ),
        ],
      ),
    );
  }
}
