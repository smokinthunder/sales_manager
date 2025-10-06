import 'dart:ui';

Color colorFromSimpleHash(String input) {
  int hash = 0;
  for (int codeUnit in input.codeUnits) {
    hash =
        (hash * 31 + 300 + codeUnit) % 0xFFFFFF; // Keep it in 24-bit range (like colors)
  }
  final hex = hash.toRadixString(16).padLeft(6, '0');

  return Color(int.parse('0xFF$hex')); // Add alpha (FF) at the start
}
