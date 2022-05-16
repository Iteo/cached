import 'gen.dart';

void main(List<String> arguments) {
  final a = Gen(1, b: '');
  () async {
    print(await a.call('Test'));
  }();
  print('Hello world!');
}
