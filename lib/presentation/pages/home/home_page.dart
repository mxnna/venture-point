import 'package:flutter/material.dart';

import '../destination/city_details_page.dart';
import '../flight/flight_search_page.dart';
import '../hotel/hotel_search_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and Title
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Venture Point',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2B28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Quick Action Buttons
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E2B28),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickActionButton(
                    context,
                    'Discover',
                    Icons.explore,
                    () {
                      Navigator.of(context).pushNamed(CityDetailsPage.routeName);
                    },
                  ),
                  _buildQuickActionButton(
                    context,
                    'Flights',
                    Icons.flight,
                    () {
                      Navigator.of(context).pushNamed(FlightSearchPage.routeName);
                    },
                  ),
                  _buildQuickActionButton(
                    context,
                    'Hotels',
                    Icons.hotel,
                    () {
                      Navigator.of(context).pushNamed(HotelSearchPage.routeName);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Placeholder for more content
              const Expanded(
                child: Center(
                  child: Text(
                    'Welcome to Venture Point!\nExplore destinations, book flights and hotels.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E2B28),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: const Color(0xFFEA8A7E),
            foregroundColor: const Color(0xFFF6F5F1),
          ),
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2E2B28),
          ),
        ),
      ],
    );
  }
}
