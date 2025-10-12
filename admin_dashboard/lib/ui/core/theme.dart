import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

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
    iconTheme: const IconThemeData(color: AppColors.white, size: 18),
  ),
  cardColor: AppColors.white,
  colorScheme: colorScheme,
  inputDecorationTheme: inputDecorationTheme,
  dropdownMenuTheme: dropDownMenuTheme,
  bottomNavigationBarTheme: bottomNavigationBarTheme,
  cardTheme: cardTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  textTheme: textTheme,
);

final colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.blue,
  onPrimary: AppColors.white,
  secondary: AppColors.green,
  onSecondary: AppColors.black,
  error: AppColors.red,
  onError: AppColors.white,
  surface: AppColors.offWhite,
  onSurface: AppColors.slate,
  tertiary: AppColors.gray,
);

final textTheme = TextTheme(
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
    color: AppColors.slate,
  ),

  // 12sp, w400
  bodySmall: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.slate,
  ),
  // 14sp, w400
  labelLarge: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  ),
  // 10sp, w400
  labelMedium: GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  ),
  // 8sp, w400
  labelSmall: GoogleFonts.poppins(
    fontSize: 8,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  ),
);

final bottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: AppColors.white,
  selectedItemColor: AppColors.blue,
  unselectedItemColor: AppColors.slate,
  selectedLabelStyle: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.blue,
  ),
  unselectedLabelStyle: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.slate,
  ),
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(140, 36),
    backgroundColor: AppColors.blue, // Blue
    foregroundColor: AppColors.white, // Text color
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
  ),
);

final dropDownMenuTheme = DropdownMenuThemeData(
  menuStyle: MenuStyle(
    padding: WidgetStatePropertyAll(EdgeInsets.zero),
    visualDensity: VisualDensity.compact,
    alignment: AlignmentDirectional.bottomStart.add(
      const AlignmentDirectional(0, 0.2),
    ),
    backgroundColor: WidgetStatePropertyAll(AppColors.white),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.gray, width: 1),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    fillColor: AppColors.white, // background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.gray, width: 1),
    ),
  ),
);

final inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: AppColors.gray.withAlpha(38), width: 1),
  ),
  fillColor: AppColors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  labelStyle: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.slate,
  ),
  hintStyle: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  ),
  errorStyle: GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  ),
);

final cardTheme = CardThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(8),
    side: BorderSide(color: AppColors.gray, width: 1),
  ),
  color: AppColors.white,
);
