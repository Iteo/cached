import 'package:flutter/material.dart';

const _textStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({
    required this.randomDouble,
    required this.randomBool,
    super.key,
  });

  final bool randomBool;
  final double randomDouble;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        height: 128,
        width: double.infinity,
        color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Random double:',
              textAlign: TextAlign.center,
              style: _textStyle,
            ),
            Text(
              '$randomDouble',
              style: _textStyle.copyWith(
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Random bool:',
              textAlign: TextAlign.center,
              style: _textStyle,
            ),
            Text(
              '$randomBool',
              style: _textStyle.copyWith(
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
