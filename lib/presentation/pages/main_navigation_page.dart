import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

import 'home/home_page.dart';
import 'saved/saved_items_page.dart';
import 'trips/trips_page.dart';
import 'profile/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  static const routeName = '/main';

  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SavedItemsPage(),
    TripsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight_takeoff),
            label: 'Trips',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textPrimary.withOpacity(0.6),
        backgroundColor: AppColors.secondary,
        onTap: _onItemTapped,
      ),
    );
  }
}
