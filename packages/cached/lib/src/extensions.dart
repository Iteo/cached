extension StringExtension on String {
  String toMethodName() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }
}
