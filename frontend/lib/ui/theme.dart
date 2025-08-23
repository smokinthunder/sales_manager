import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color blue = Color(0xFF2081bf);
  static const Color green = Color(0xFF9dc54a);
  static const Color black = Color(0xFF010101);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF999999);
  static const Color lightGrey = Color(0xFFE6E6E6);
  static const Color darkGrey = Color(0xFF484c52);
  static const Color red = Color(0xFFff383c);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.blue,
  scaffoldBackgroundColor: AppColors.white,

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.blue,
    foregroundColor: AppColors.white,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.blue,
    onPrimary: AppColors.white,
    secondary: AppColors.green,
    onSecondary: AppColors.black,
    error: AppColors.red,
    onError: AppColors.white,
    surface: AppColors.lightGrey,
    onSurface: AppColors.darkGrey,
    tertiary: AppColors.grey,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    labelStyle: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkGrey,
    ),
    hintStyle: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grey,
    ),
    errorStyle: GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: AppColors.red,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blue, // Blue
      foregroundColor: AppColors.white, // Text color
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),
  textTheme: TextTheme(
    // 24sp, w500
    headlineLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),

    // 20sp, w500
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),

    // 18sp, w500
    headlineSmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),

    // 16sp, w500
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),

    // 14sp, w500
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkGrey,
    ),

    // 12sp, w400
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.darkGrey,
    ),
    // 14sp, w400
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grey,
    ),
    // 10sp, w400
    labelSmall: GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: AppColors.grey,
    ),
  ),
);
