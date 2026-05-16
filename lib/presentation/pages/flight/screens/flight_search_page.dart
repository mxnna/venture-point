import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class FlightSearchPage extends StatelessWidget {
  static const routeName = '/flights';

  const FlightSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('Flights')),
      body: const Center(child: Text('Flight Search Page')),
    );
  }
}
