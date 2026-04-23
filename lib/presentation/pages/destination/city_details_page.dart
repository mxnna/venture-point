import 'package:flutter/material.dart';

class CityDetailsPage extends StatelessWidget {
  static const routeName = '/destinations';

  const CityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      appBar: AppBar(
        title: const Text('Destinations'),
      ),
      body: const Center(
        child: Text('Destinations Page'),
      ),
    );
  }
}
