import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Secure {
  static const _storage = FlutterSecureStorage();

  static _Key get store => _Key();

  // 내부 헬퍼 클래스
  // Secure.store.saveAccessToken(...) 처럼 쓰게끔
  // 확장성 있게 access / refresh 분리
}

class _Key {
  final _storage = const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'accessToken', value: token);
  }

  Future<String?> readAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refreshToken', value: token);
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
