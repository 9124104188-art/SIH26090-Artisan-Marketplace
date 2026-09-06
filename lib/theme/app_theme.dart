import 'package:flutter/material.dart';

class AppColors {
  static const green = Color(0xFF0B8F56);
  static const darkGreen = Color(0xFF006B43);
  static const softGreen = Color(0xFFE9F7F0);
  static const border = Color(0xFFE4E8E6);
  static const text = Color(0xFF1E2723);
  static const muted = Color(0xFF66736D);
  static const gold = Color(0xFFF0A600);
  static const red = Color(0xFFD32F2F);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: AppColors.green, brightness: Brightness.light);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme.copyWith(primary: AppColors.green, secondary: AppColors.darkGreen),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F9F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.green, width: 1.5),
      ),
    ),
  );
}
