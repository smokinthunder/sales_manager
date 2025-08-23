import 'package:flutter/material.dart';

class AppColors {
  // Primary colors

  /// Steel Blue
  static const Color blue = Color(0xFF2081BF);

  /// Yellow Green
  static const Color green = Color(0xFF9DC54A);

  static const Color black = Color(0xFF010101);
  static const Color white = Color(0xFFFFFFFF);

  // Secondary colors

  /// Battle Ship Gray
  static const Color gray = Color(0xFF999999);

  /// Outer Space
  static const Color slate = Color(0xFF484C52);

  /// Platinum
  static const Color offWhite = Color(0xFFE6E6E6);

  //Gradient

  /// Gradient with steel blue and yellow green
  static const LinearGradient blueGreenGradient = LinearGradient(
    colors: [blue, green],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
  );

  // Custom colors
  /// Engineering Orange
  static const Color red = Color(0xFFff383c);
}
