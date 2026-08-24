import 'package:flutter/material.dart';

class AppColors {
  // Soothing Palette from Image
  static const Color softPurple = Color(0xFF9D7BFF);
  static const Color softPink = Color(0xFFFF8EAB);
  static const Color lightPink = Color(0xFFFFC2D1);
  static const Color paleBlue = Color(0xFFE0F7FA);
  static const Color skyBlue = Color(0xFF81D4FA);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Backward Compatibility for Theme Migration
  static const Color backgroundDeep = backgroundLight;
  static const Color backgroundSurface = surfaceWhite;
  
  // Mapping for consistency with existing code
  static const Color primaryCyan = softPurple; // Using purple as primary
  static const Color neonEmerald = softPink;   // Using pink as secondary
  static const Color sunsetGold = skyBlue;    // Using sky blue for accents
  
  // Text
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  
  // Glassmorphism (Light Mode)
  static Color glassWhite = Colors.white.withOpacity(0.7);
  static Color glassBorder = Colors.white.withOpacity(0.4);
  
  // Gradients
  static const List<Color> soothingGradient = [paleBlue, Colors.white];
}
