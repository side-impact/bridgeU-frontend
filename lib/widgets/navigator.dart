import 'package:flutter/material.dart';
import '../screens/translate_screen.dart';
import '../screens/community_screen.dart';
import '../screens/chatbot_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.translate), label: 'Translate'),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Community'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TranslateScreen()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CommunityScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        }
      },
    );
  }
}