import 'package:flutter/material.dart';
import '../widgets/navigator.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: const Center(child: Text('Chatbot Screen')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}