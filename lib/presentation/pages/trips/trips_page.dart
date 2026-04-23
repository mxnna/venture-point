import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  static const routeName = '/trips';

  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      appBar: AppBar(
        title: const Text('Trips'),
      ),
      body: const Center(
        child: Text('Trips Page'),
      ),
    );
  }
}
