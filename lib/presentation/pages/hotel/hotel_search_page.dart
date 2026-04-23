import 'package:flutter/material.dart';

class HotelSearchPage extends StatelessWidget {
  static const routeName = '/hotels';

  const HotelSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      appBar: AppBar(
        title: const Text('Hotel Search'),
      ),
      body: const Center(
        child: Text('Hotel Search Page'),
      ),
    );
  }
}
