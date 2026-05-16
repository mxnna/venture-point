import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF375B96);
  static const Color primaryLight = Color(0xFF4C6B9E);
  static const Color primaryVeryLight = Color(0xFF7A90B2);
  static const Color primaryDark = Color(0xFFD46A5E);

  // Secondary Colors
  static const Color secondary = Color(0xFFFCFCFD);
  static const Color secondaryDark = Color(0xFFE8E5DF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2E2B28);
  static const Color textSecondary = Color(0xFF9C9996);
  static const Color textMuted = Color(0xFF7B8B87);
  static const Color textLight = Color(0xFFF6F5F1);

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
      primary.withValues(alpha: opacity);
  static Color textWithOpacity(double opacity) =>
      textPrimary.withValues(alpha: opacity);
}
