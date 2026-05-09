import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

import '../../widgets/app_header.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/quick_action_buttons.dart';
import '../flight/flight_search_page.dart';
import '../hotel/hotel_search_page.dart';
import '../profile/profile_page.dart';
import '../trips/discover_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
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
                      backgroundColor: AppColors.white,
                      textColor: AppColors.textPrimary,
                      hintColor: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 28),
                    QuickActionButtons(
                      buttons: [
                        QuickActionButton(
                          label: 'Discover',
                          icon: Icons.explore,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(DiscoverPage.routeName);
                          },
                        ),
                        QuickActionButton(
                          label: 'Hotels',
                          icon: Icons.apartment,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(HotelSearchPage.routeName);
                          },
                        ),
                        QuickActionButton(
                          label: 'Flights',
                          icon: Icons.flight,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(FlightSearchPage.routeName);
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
