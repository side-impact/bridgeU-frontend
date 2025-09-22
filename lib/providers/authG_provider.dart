import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool get isLoggedIn => _repository.user != null;
  String get userName => _repository.user?.displayName ?? '';
  String get userEmail => _repository.user?.email ?? '';

  Future<void> login() async {
    await _repository.signInWithGoogle();
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.signOut();
    notifyListeners();
  }
}
