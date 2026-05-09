import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class HotelSearchPage extends StatelessWidget {
  static const routeName = '/hotels';

  const HotelSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('Hotels')),
      body: const Center(child: Text('Hotel Search Page')),
    );
  }
}
