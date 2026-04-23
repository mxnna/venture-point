import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/pages/onboarding_page.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/main_navigation_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/saved/saved_items_page.dart';
import 'presentation/pages/trips/discover_page.dart';
import 'presentation/pages/trips/trips_page.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/flight/flight_search_page.dart';
import 'presentation/pages/hotel/hotel_search_page.dart';
import 'presentation/pages/destination/city_details_page.dart';

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
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
      routes: {
        OnboardingPage.routeName: (_) {
          debugPrint('Building OnboardingPage');
          return const OnboardingPage();
        },
        MainNavigationPage.routeName: (_) => const MainNavigationPage(),
        HomePage.routeName: (_) => const HomePage(),
        SavedItemsPage.routeName: (_) => const SavedItemsPage(),
        DiscoverPage.routeName: (_) => const DiscoverPage(),
        TripsPage.routeName: (_) => const TripsPage(),
        ProfilePage.routeName: (_) => const ProfilePage(),
        FlightSearchPage.routeName: (_) => const FlightSearchPage(),
        HotelSearchPage.routeName: (_) => const HotelSearchPage(),
        CityDetailsPage.routeName: (_) => const CityDetailsPage(),
      },
    );
  }
}
