import 'dart:math';

class TestDataProvider {
  final Random _random = Random();

  int getCurrentTimestamp() => DateTime.now().millisecondsSinceEpoch;

  int getRandomValue() => _random.nextInt(99999);

  Future<int> fetchRandomValue() => Future.value(getRandomValue());

  Future<int> fetchCurrentTimestamp() => Future.value(getCurrentTimestamp());

}