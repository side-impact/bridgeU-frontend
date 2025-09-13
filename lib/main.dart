import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const BridgeUApp());
}

class BridgeUApp extends StatelessWidget {
  const BridgeUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}