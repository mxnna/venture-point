import 'dart:async';

import 'package:flutter/material.dart';

import 'onboarding_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(OnboardingPage.routeName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      body: Center(
        child: Image.asset(
          'assets/images/venture_point_logo.png',
          width: 240,
          height: 240,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.flight_takeoff,
              size: 120,
              color: Color(0xFFEA8A7E),
            );
          },
        ),
      ),
    );
  }
}
