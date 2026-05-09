import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/pages/auth/auth_wrapper.dart';
import 'presentation/pages/onboarding_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/sign_up_page.dart';
import 'presentation/pages/auth/forgot_password_page.dart';
import 'presentation/pages/main_navigation_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/saved/saved_items_page.dart';
import 'presentation/pages/trips/discover_page.dart';
import 'presentation/pages/trips/trips_page.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/flight/flight_search_page.dart';
import 'presentation/pages/hotel/hotel_search_page.dart';

import 'presentation/pages/profile/visited_cities_page.dart';
import 'presentation/pages/profile/visited_countries_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const VenturePointApp());
}

class VenturePointApp extends StatelessWidget {
  const VenturePointApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('VenturePointApp build called');
    return BlocProvider(
      create: (_) {
        final bloc = di.sl<AuthBloc>();
        bloc.add(AuthCheckRequested());
        return bloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VenturePoint',
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        routes: {
          OnboardingPage.routeName: (_) {
            debugPrint('Building OnboardingPage');
            return const OnboardingPage();
          },
          LoginPage.routeName: (_) => const LoginPage(),
          SignUpPage.routeName: (_) => const SignUpPage(),
          ForgotPasswordPage.routeName: (_) => const ForgotPasswordPage(),
          MainNavigationPage.routeName: (_) => const MainNavigationPage(),
          HomePage.routeName: (_) => const HomePage(),
          SavedItemsPage.routeName: (_) => const SavedItemsPage(),
          DiscoverPage.routeName: (_) => const DiscoverPage(),
          TripsPage.routeName: (_) => const TripsPage(),
          ProfilePage.routeName: (_) => const ProfilePage(),
          VisitedCountriesPage.routeName: (_) => const VisitedCountriesPage(),
          VisitedCitiesPage.routeName: (_) => const VisitedCitiesPage(),
          FlightSearchPage.routeName: (_) => const FlightSearchPage(),
          HotelSearchPage.routeName: (_) => const HotelSearchPage(),
        },
      ),
    );
  }
}
