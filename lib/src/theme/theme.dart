import 'package:flutter/material.dart';

class AppColors {
  static Color lightPurple = Color(0xFF6C63FF);
  static Color cyan = Color.fromARGB(255, 0, 223, 212);
  static Color darkBrown = Color(0xFF1E1E1E);
  static Color lightBrown = Color(0xFF2C2C2C); 
  static Color white = Color(0xFFF5F6FA);
  static Color lightGreen = Color(0xFF00DF9A);
  static Color lightRed = Color(0xFFFF4757);
  static Color black = Color(0xFF121212);
}

ThemeData primaryTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.black,
  primaryColor: AppColors.lightPurple,
  cardColor: AppColors.darkBrown,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkBrown,
    foregroundColor: AppColors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    secondary: AppColors.lightGreen,
    surface: AppColors.darkBrown,
    error: AppColors.lightRed,
    onSurface: AppColors.white,
  ),
);
