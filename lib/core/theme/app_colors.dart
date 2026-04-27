import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFEA8A7E); // Coral/Salmon
  static const Color primaryLight = Color(0xFFF5A9A0);
  static const Color primaryDark = Color(0xFFD46A5E);

  // Secondary Colors
  static const Color secondary = Color(0xFFF6F5F1); // Warm Beige/Background
  static const Color secondaryDark = Color(0xFFE8E5DF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2E2B28); // Dark Brown
  static const Color textSecondary = Color(0xFF9C9996); // Light Brown/Gray
  static const Color textMuted = Color(0xFF7B8B87); // Muted Gray
  static const Color textLight = Color(0xFFF6F5F1); // Light Background

  // Functional Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFF6F5F1);

  // Transparency variants
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color textWithOpacity(double opacity) =>
      textPrimary.withOpacity(opacity);
}
