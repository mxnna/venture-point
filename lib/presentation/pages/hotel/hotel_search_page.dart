import 'package:flutter/material.dart';

import 'screens/hotel_list_screen.dart';

class HotelSearchPage extends StatelessWidget {
  static const routeName = '/hotels';

  const HotelSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HotelListScreen();
  }
}
