import 'package:flutter/material.dart';

class AppColors {
  // Theme from Invoice Generator
  static const Color primary = Color(0xFFFF9F43); // Orange/Amber
  static const Color secondary = Color(0xFF2D2A26); // Dark Slate/Charcoal

  // Background Gradients
  static const Color bgStart = Color(0xFFFFF9F0);
  static const Color bgEnd = Color(0xFFE8F9FC);

  // Surface
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF2D2A26);
  static const Color textSecondary = Color(0xFF64748B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Accents
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);

  // Backward compatibility aliases (if needed temporarily)
  static const Color softPurple = accentPurple;
  static const Color softPink = Color(0xFFFF8EAB);
  static const Color lightPink = Color(0xFFFFC2D1);
  static const Color paleBlue = Color(0xFFE0F7FA);
  static const Color skyBlue = Color(0xFF81D4FA);
  static const Color backgroundDeep = bgStart;
  static const Color backgroundSurface = surface;
  static const Color primaryCyan = primary;
  static const Color neonEmerald = success;
  static const Color sunsetGold = warning;
}
