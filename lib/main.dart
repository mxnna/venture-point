import 'package:flutter/material.dart';

import 'presentation/pages/onboarding_page.dart';
import 'presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VenturePointApp());
}

class VenturePointApp extends StatelessWidget {
  const VenturePointApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('VenturePointApp build called');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VenturePoint',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFEA8A7E),
          onPrimary: Color(0xFFF6F5F1),
          surface: Color(0xFFF6F5F1),
          onSurface: Color(0xFF2E2B28),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F5F1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEA8A7E),
          foregroundColor: Color(0xFFF6F5F1),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEA8A7E),
            foregroundColor: const Color(0xFFF6F5F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(56),
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        OnboardingPage.routeName: (_) {
          debugPrint('Building OnboardingPage');
          return const OnboardingPage();
        },
      },
    );
  }
}
