import 'package:flutter/material.dart';

class FlightSearchPage extends StatelessWidget {
  static const routeName = '/flights';

  const FlightSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      appBar: AppBar(title: const Text('Flights')),
      body: const Center(child: Text('Flight Search Page')),
    );
  }
}
