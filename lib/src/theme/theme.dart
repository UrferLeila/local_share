import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';

class AppColors {
  static Color lightwhite = Color(0xFFF5F6FA);
  static Color grey = Color(0xFFA4B0BE);
  static Color cyan = Color.fromARGB(255, 0, 223, 212);
  static Color lightGreen = Color(0xFF00DF9A);
  static Color lightPurple = Color(0xFF6C63FF);
  static Color lightRed = Color(0xFFFF4757);
  static Color lightBrown = Color(0xFF2C2C2C);
  static Color darkBrown = Color(0xFF1E1E1E);
  static Color black = Color(0xFF121212);
}

ThemeData primaryTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.black,
  primaryColor: AppColors.lightPurple,
  cardColor: AppColors.darkBrown,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkBrown,
    foregroundColor: AppColors.lightwhite,
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    secondary: AppColors.lightGreen,
    surface: AppColors.darkBrown,
    error: AppColors.lightRed,
    onSurface: AppColors.lightwhite,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightBrown,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Sizes.p16,
      vertical: Sizes.p16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide(
        color: AppColors.lightPurple.withValues(alpha: 0.3),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide(color: AppColors.lightPurple, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide(color: AppColors.lightRed, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.p12),
      borderSide: BorderSide(color: AppColors.lightRed, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.lightwhite),
    hintStyle: TextStyle(color: AppColors.lightwhite.withValues(alpha: 0.5)),
    prefixIconColor: AppColors.lightPurple,
  ),
);
