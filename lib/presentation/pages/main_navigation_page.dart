import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

import 'flight/flight_search_page.dart';
import 'home/home_page.dart';
import 'hotel/hotel_search_page.dart';
import 'profile/profile_page.dart';
import 'saved/saved_items_page.dart';
import 'trips/discover_page.dart';
import 'trips/trips_page.dart';

class MainNavigationPage extends StatefulWidget {
  static const routeName = '/main';

  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    4,
    (_) => GlobalKey<NavigatorState>(),
  );

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == Navigator.defaultRouteName) {
          return MaterialPageRoute(builder: (_) => _buildInitialPage(index));
        }

        switch (settings.name) {
          case DiscoverPage.routeName:
            return MaterialPageRoute(builder: (_) => const DiscoverPage());
          case FlightSearchPage.routeName:
            return MaterialPageRoute(builder: (_) => const FlightSearchPage());
          case HotelSearchPage.routeName:
            return MaterialPageRoute(builder: (_) => const HotelSearchPage());
          case ProfilePage.routeName:
            return MaterialPageRoute(builder: (_) => const ProfilePage());
          case HomePage.routeName:
            return MaterialPageRoute(builder: (_) => const HomePage());
          case SavedItemsPage.routeName:
            return MaterialPageRoute(builder: (_) => const SavedItemsPage());
          case TripsPage.routeName:
            return MaterialPageRoute(builder: (_) => const TripsPage());
          default:
            return MaterialPageRoute(builder: (_) => _buildInitialPage(index));
        }
      },
    );
  }

  Widget _buildInitialPage(int index) {
    switch (index) {
      case 1:
        return const SavedItemsPage();
      case 2:
        return const TripsPage();
      case 3:
        return const ProfilePage();
      case 0:
      default:
        return const HomePage();
    }
  }

  Future<bool> _onWillPop() async {
    final NavigatorState? currentNavigator = _navigatorKeys[_selectedIndex].currentState;
    if (currentNavigator == null) {
      return true;
    }

    if (await currentNavigator.maybePop()) {
      return false;
    }
    return true;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: List.generate(4, _buildTabNavigator),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Trips'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textPrimary.withOpacity(0.6),
          backgroundColor: AppColors.secondary,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
