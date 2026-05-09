import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import 'login_page.dart';
import '../main_navigation_page.dart';
import '../splash_page.dart';
import '../onboarding_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplash = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    // Show splash for 2 seconds, then show onboarding
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
          _showOnboarding = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (_showSplash) {
          return const SplashPage();
        }

        if (_showOnboarding) {
          return const OnboardingPage();
        }

        if (state is AuthAuthenticated) {
          return const MainNavigationPage();
        } else {
          // For AuthUnauthenticated, AuthError, or any other state, show login
          return const LoginPage();
        }
      },
    );
  }
}
