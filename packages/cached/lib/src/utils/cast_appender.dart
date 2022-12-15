import 'package:meta/meta.dart';

class CastAppender {
  String wrapWithTryCatchAndAddGenericCast({
    required String returnType,
    required String codeToWrap,
  }) {
    final result = appendCastIfNeeded(returnType);
    return """
         try {
            $codeToWrap$result;
         } on NoSuchMethodError {
            throw Exception('''
             You have to provide your generic classes with a `.cast<T>()` 
             method, if you want to store them inside a persistent storage. 
             E.g.:
             
             class MyClass<T> {
               // ...       
                       
               MyClass<S> cast<S>() {
                 return MyClass<S>();
               }
             }

            ''');
         }
      """;
  }

  @visibleForTesting
  String appendCastIfNeeded(String returnType) {
    final startsWithFuture = returnType.startsWith('Future<');
    if (startsWithFuture) {
      return _generate(returnType);
    }

    return '';
  }

  String _generate(String returnType) {
    final type = _getGenericType(returnType);
    final isGeneric = type.contains('<') && type.contains('>');

    if (isGeneric) {
      return _generateCast(type);
    }

    return '';
  }

  String _getGenericType(String type) {
    final start = type.indexOf('<');
    final stop = type.lastIndexOf('>');
    final result = type.substring(start + 1, stop);

    return result;
  }

  String _generateCast(String type) {
    final nestedType = _getGenericType(type);
    final castMethod = '.cast<$nestedType>()';

    return castMethod;
  }
}
