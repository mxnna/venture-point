import 'package:flutter/material.dart';

import 'flight_home_screen.dart';

class FlightSearchPage extends StatelessWidget {
  static const routeName = '/flight-search';

  const FlightSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const flight_home_screen();
  }
}
