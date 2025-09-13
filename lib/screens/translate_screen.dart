import 'package:flutter/material.dart';
import '../widgets/navigator.dart';

class TranslateScreen extends StatelessWidget {
  const TranslateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translate')),
      body: const Center(child: Text('Translate Screen')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}