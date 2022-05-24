import 'dart:convert';

import 'gen.dart';

/// Open gen.dart file to check how use [Cached] package,
/// if you need more information about the package,
/// take a look at the readme!

/// Run main method to check how great [Cached] package is it!
void main(List<String> arguments) async {
  print('======= CACHED BY ITEO =======\n');

  final gen = Gen();
  final sw = Stopwatch();

  final response = await gen.getDataWithCached();

  print('Response json:');
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(jsonDecode(response.body));
  print("$prettyprint\n");

  sw.start();
  await gen.getDataWithCached();
  sw.stop();

  print("With cached: ${sw.elapsedMilliseconds} ms");

  sw.start();
  await gen.getDataWithoutCached();
  sw.stop();

  print("Without cached: ${sw.elapsedMilliseconds} ms");

  print('\n==============================');
}
