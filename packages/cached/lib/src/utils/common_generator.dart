import 'package:source_gen/source_gen.dart';

class CommonGenerator {
  static String generatePersistentStorageAwait({
    required bool isPersisted,
    required bool isAsync,
    required String name,
  }) {
    if (!isPersisted) {
      return '';
    }

    if (!isAsync) {
      final message = '[ERROR] $name has to be async and return Future, '
          'if you want to use persistent storage.';
      throw InvalidGenerationSourceError(message);
    }

    return '''
       if (PersistentStorageHolder.isStorageSet) {
          await _completerFuture; 
       }
    ''';
  }
}
