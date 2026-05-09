import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
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
              color: AppColors.primary,
            );
          },
        ),
      ),
    );
  }
}
