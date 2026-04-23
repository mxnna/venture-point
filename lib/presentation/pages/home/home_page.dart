import 'package:flutter/material.dart';

import '../../widgets/app_header.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/quick_action_buttons.dart';
import '../destination/city_details_page.dart';
import '../flight/flight_search_page.dart';
import '../hotel/hotel_search_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo, name, and icons
                AppHeader(
                  logoPath: 'assets/images/logo.png',
                  appName: 'Venture Point',
                  onNotificationTap: () {
                    // Handle notification tap
                  },
                  onProfileTap: () {
                    Navigator.of(context).pushNamed(ProfilePage.routeName);
                  },
                ),
                const SizedBox(height: 32),
                // Search Bar
                SearchBarWidget(
                  hintText: 'Search destinations, hotels, flights...',
                  onFilterTap: () {
                    // Handle filter tap
                  },
                ),
                const SizedBox(height: 32),
                // Quick Action Buttons
                QuickActionButtons(
                  buttons: [
                    QuickActionButton(
                      label: 'Discover',
                      icon: Icons.explore,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(CityDetailsPage.routeName);
                      },
                    ),
                    QuickActionButton(
                      label: 'Flights',
                      icon: Icons.flight,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(FlightSearchPage.routeName);
                      },
                    ),
                    QuickActionButton(
                      label: 'Hotels',
                      icon: Icons.hotel,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(HotelSearchPage.routeName);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
