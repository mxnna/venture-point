import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  static const routeName = '/discover';

  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F1),
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: const Center(
        child: Text('Discover Page'),
      ),
    );
  }
}
