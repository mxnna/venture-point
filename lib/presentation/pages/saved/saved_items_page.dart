import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class SavedItemsPage extends StatelessWidget {
  static const routeName = '/saved';

  const SavedItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('Saved Items')),
      body: const Center(child: Text('Saved Items Page')),
    );
  }
}
