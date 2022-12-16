extension StringExtension on String {
  String startsWithLowerCase() {
    final lowerCase = this[0].toLowerCase();
    final textPart = substring(1);

    return '$lowerCase$textPart';
  }
}
