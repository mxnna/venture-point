import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class TripsPage extends StatelessWidget {
  static const routeName = '/trips';

  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('Trips')),
      body: const Center(child: Text('Trips Page')),
    );
  }
}
