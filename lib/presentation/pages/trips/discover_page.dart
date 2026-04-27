import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class DiscoverPage extends StatelessWidget {
  static const routeName = '/discover';

  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('Discover')),
      body: const Center(child: Text('Discover Page')),
    );
  }
}
