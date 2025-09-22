import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/community_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/theme.dart';
import 'utils/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("jwtToken"); // 기존 토큰 강제 삭제

  final authProvider = AuthProvider();
  await authProvider.tryAutoLogin(); // 앱 시작 시 체크 (이제 항상 null)

  runApp(
    ChangeNotifierProvider.value(
      value: authProvider,
      child: const BridgeUApp(),
    ),
  );
}

class BridgeUApp extends StatelessWidget {
  const BridgeUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'BridgeU',
          debugShowCheckedModeBanner: false,
          theme: brandTheme,
          navigatorKey: navigatorKey, // Global navigator key 설정
          routes: {
            '/login': (ctx) => const LoginScreen(),
            '/community': (ctx) => const CommunityScreen(),
          },
          home: authProvider.isLoggedIn
              ? const CommunityScreen()
              : const LoginScreen(),
        );
      },
    );
  }
}

