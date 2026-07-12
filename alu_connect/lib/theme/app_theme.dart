import 'package:flutter/material.dart';

/// Central place for colors/text styles so every screen looks consistent.
/// Matches the purple/indigo look from the sample UI (Hello Amina screens).
class AppTheme {
  static const Color primary = Color(0xFF6C5CE7); // main purple
  static const Color primaryDark = Color(0xFF4834D4);
  static const Color accentPink = Color(0xFFFF9AA2);
  static const Color background = Color(0xFFF7F7FC);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF8A8A9E);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF9B7CF0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        background: background,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
