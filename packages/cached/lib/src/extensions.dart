extension StringExtension on String {
  String startsWithLowerCase() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }
}
