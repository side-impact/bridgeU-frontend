import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool get isLoggedIn => _token != null;

  String? get token => _token;

  static const String baseUrl =
      "http://172.17.176.1:8080"; // 백엔드 주소 (나중에 서버 주소로 변경)

  /// 앱 실행 시 자동 로그인 체크
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString("jwtToken");

    if (storedToken != null && storedToken.isNotEmpty) {
      _token = storedToken;
      notifyListeners();
      debugPrint("Stored token found: $_token"); // ← 여기에 추가
    } else {
      debugPrint("No stored token found"); // ← 토큰이 없을 때
    }
  }

  /// 로그인 요청
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];
        if (token != null) {
          _token = token;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("jwtToken", token);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }

  /// 회원가입 요청
  Future<bool> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password, "name": name}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];
        if (token != null) {
          _token = token;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("jwtToken", token);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Register error: $e");
      return false;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwtToken");
    notifyListeners();
  }
}
