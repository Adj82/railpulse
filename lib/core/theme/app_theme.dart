import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.softPurple,
        secondary: AppColors.softPink,
        surface: AppColors.surfaceWhite,
        error: Colors.redAccent,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
        ),
        elevation: 4,
        shadowColor: AppColors.softPurple.withOpacity(0.1),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.softPurple,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Keeping darkTheme just in case, but updating it to be deprecated or renamed
  static ThemeData get darkTheme => lightTheme; 

  static BoxDecoration get glassDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.6),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: AppColors.softPurple.withOpacity(0.05),
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  );

  static BoxDecoration get glowBorderDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: AppColors.softPurple.withOpacity(0.3),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.softPurple.withOpacity(0.1),
        blurRadius: 15,
        spreadRadius: 2,
      ),
    ],
  );
}
