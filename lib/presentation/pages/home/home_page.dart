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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Venture Point',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2E2B28),
                          fontFamily: 'TT Milks Casual Pie Base',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
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
              ],
            ),
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
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEA8A7E),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEA8A7E).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 32,
                color: const Color(0xFFF6F5F1),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E2B28),
            ),
          ),
        ],
      ),
    );
  }
}
