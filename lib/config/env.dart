// lib/config/env.dart
class Env {
  static const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:8080');
  static const papagoKey = String.fromEnvironment('PAPAGO_KEY', defaultValue: '');
}