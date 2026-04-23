import 'package:flutter/material.dart';

class SavedItemsPage extends StatelessWidget {
  static const routeName = '/saved';

  const SavedItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      appBar: AppBar(
        title: const Text('Saved Items'),
      ),
      body: const Center(
        child: Text('Saved Items Page'),
      ),
    );
  }
}
