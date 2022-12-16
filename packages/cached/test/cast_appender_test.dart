import 'package:cached/src/utils/type_cast_appender.dart';
import 'package:test/test.dart';

typedef TestFunction = void Function(String, String);

void main() {
  final testData = {
    'int': '',
    'List<Todo>': '',
    'Future<Car>': '',
    'Future<List<Todo>>': '.cast<Todo>()',
    'List': '',
    'Map<String, int>': '',
    'Future<Map<String, int>>': '.cast<String, int>()',
    'MyClass<Map<String, int>>': '',
    'Future<MyClass<Map<String, int>>>': '.cast<Map<String, int>>()',
    'Future<List<dynamic>>': '.cast<dynamic>()',
    'Future<Map<Todo, Map<String, List<Todo>>>>':
        '.cast<Todo, Map<String, List<Todo>>>()',
  };

  TestFunction getAppenderFunction({
    required bool usingStorage,
  }) {
    return (String input, String expected) {
      final appender = TypeCastAppender();

      test('Should generate correct cast for $input', () {
        final result = appender.appendCastIfNeeded(input);
        expect(result, expected);
      });
    };
  }

  group('shouldUsePersistentStorage == true', () {
    final testAppending = getAppenderFunction(usingStorage: true);
    testData.forEach(testAppending);
  });
}
