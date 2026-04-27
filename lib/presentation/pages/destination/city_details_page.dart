import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class CityDetailsPage extends StatelessWidget {
  static const routeName = '/destinations';

  const CityDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('Destinations')),
      body: const Center(child: Text('Destinations Page')),
    );
  }
}
