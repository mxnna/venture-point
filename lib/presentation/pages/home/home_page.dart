import 'package:flutter/material.dart';

import '../../widgets/app_header.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/quick_action_buttons.dart';
import '../flight/flight_search_page.dart';
import '../hotel/hotel_search_page.dart';
import '../profile/profile_page.dart';
import '../trips/trips_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 24),
                    SearchBarWidget(
                      hintText: 'Search destinations, hotels, flights...',
                      onFilterTap: () {
                        // Handle filter tap
                      },
                      backgroundColor: Colors.white,
                      textColor: const Color(0xFF2E2B28),
                      hintColor: const Color(0xFF9C9996),
                    ),
                    const SizedBox(height: 28),
                    QuickActionButtons(
                      buttons: [
                        QuickActionButton(
                          label: 'Trips',
                          icon: Icons.card_travel,
                          onPressed: () {
                            Navigator.of(context).pushNamed(TripsPage.routeName);
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
                        QuickActionButton(
                          label: 'Flights',
                          icon: Icons.flight,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(FlightSearchPage.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
