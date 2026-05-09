import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors - Dark green and blue theme
  static const Color primaryColor = Color(0xFF1B5E20); // Dark Green
  static const Color secondaryColor = Color(0xFF00695C); // Teal
  static const Color accentColor = Color(0xFF0277BD); // Blue

  // Background colors
  static const Color darkBg = Color(0xFF0F1419); // Very dark background
  static const Color cardBg = Color(0xFF1A1F26); // Card background
  static const Color surfaceBg = Color(0xFF121820); // Surface background

  // Status colors
  static const Color goodAqi = Color(0xFF4CAF50); // Green
  static const Color moderateAqi = Color(0xFFFFC107); // Yellow
  static const Color unhealthyAqi = Color(0xFFF44336); // Red
  static const Color hazardousAqi = Color(0xFF8B00FF); // Purple

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB0B0B0); // Light gray
  static const Color textHint = Color(0xFF757575); // Medium gray

  // Gradient colors
  static const Gradient pollutionGradient = LinearGradient(
    colors: [
      Color(0xFF1B5E20),
      Color(0xFF00695C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Theme Data
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: cardBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      hintStyle: const TextStyle(color: textHint),
      labelStyle: const TextStyle(color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: textHint,
        fontSize: 12,
      ),
    ),
  );
}
