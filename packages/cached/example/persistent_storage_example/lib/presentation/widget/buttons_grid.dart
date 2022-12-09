import 'package:flutter/material.dart';
import 'package:persistent_storage_example/presentation/cubit/sample_cubit.dart';
import 'package:persistent_storage_example/presentation/widget/button.dart';

class ButtonsGrid extends StatelessWidget {
  const ButtonsGrid({
    required this.cubit,
    super.key,
  });

  final SampleCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button(
          onTap: cubit.updateDouble,
          text: 'Generate random double',
        ),
        Button(
          onTap: cubit.updateBool,
          text: 'Generate random bool',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Button(
                onTap: cubit.deleteNumber,
                text: 'Delete number',
              ),
            ),
            Expanded(
              child: Button(
                onTap: cubit.deleteAll,
                text: 'Delete all cached data',
              ),
            )
          ],
        ),
        Button(
          onTap: cubit.deleteSelected,
          text: 'Delete getNumber, getText',
        ),
      ],
    );
  }
}
