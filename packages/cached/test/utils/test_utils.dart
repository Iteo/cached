import 'dart:math';

class TestDataProvider {
  final Random _random = Random();

  int getCurrentTimestamp() => DateTime.now().millisecondsSinceEpoch;

  int getRandomValue() => _random.nextInt(99999);

}