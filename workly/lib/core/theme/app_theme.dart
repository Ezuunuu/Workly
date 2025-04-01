import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF4F46E5);
  static const background = Color(0xFFF9FAFB);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const blockBackground = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    fontFamily: 'Pretendard',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF1F2937),
    primaryColor: AppColors.primary,
    fontFamily: 'Pretendard',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
    ),
  );
}
