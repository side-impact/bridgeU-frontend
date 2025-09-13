import 'package:flutter/material.dart';
import '../widgets/navigator.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: const Center(child: Text('Community Feed')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}