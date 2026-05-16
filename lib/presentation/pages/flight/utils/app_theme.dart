import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const navy      = Color(0xFF1B3A6B);
  static const blue      = Color(0xFF2E6BC4);
  static const lightBlue = Color(0xFFEBF2FC);
  static const beige     = Color(0xFFF5F0E8);
  static const beige2    = Color(0xFFEDE6D6);
  static const beige3    = Color(0xFFC8BEA8);
  static const textDark  = Color(0xFF1B2B45);
  static const textMuted = Color(0xFF7A8BAA);
  static const white     = Color(0xFFFFFFFF);
  static const green     = Color(0xFF2E7D45);
  static const greenBg   = Color(0xFFE8F5EC);
  static const amber     = Color(0xFF9A6100);
  static const amberBg   = Color(0xFFFEF3E2);
  static const navyLight = Color(0xFF1A3460);
  static const navyMid   = Color(0xFF162E58);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy),
    scaffoldBackgroundColor: AppColors.beige,
    textTheme: GoogleFonts.dmSansTextTheme(),
    useMaterial3: true,
  );
}
