//다국어 지원용 문자열
//기본, 수정 가능
import 'dart:convert';
import 'package:flutter/services.dart';
import '../storage/prefs.dart';

class AppStrings {
  static Map<String, String> _localizedStrings = {};
  static String _currentLanguage = 'en';

  /// 앱 시작 시 언어 로드
  static Future<void> initialize() async {
    _currentLanguage = await PrefsStorage.getLanguage();
    await _loadLanguage(_currentLanguage);
  }

  /// 특정 언어로 변경
  static Future<void> changeLanguage(String languageCode) async {
    if (languageCode != _currentLanguage) {
      _currentLanguage = languageCode;
      await PrefsStorage.saveLanguage(languageCode);
      await _loadLanguage(languageCode);
    }
  }

  /// 현재 언어 코드 반환
  static String get currentLanguage => _currentLanguage;

  /// JSON 파일에서 언어 데이터 로드
  static Future<void> _loadLanguage(String languageCode) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/i18n/$languageCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      // 파일이 없으면 영어로 폴백
      if (languageCode != 'en') {
        await _loadLanguage('en');
      }
    }
  }

  /// 키로 문자열 가져오기
  static String get(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// 지원하는 언어 목록
  static const List<String> supportedLanguages = ['en', 'ja', 'zh'];
  
  /// 언어 표시명
  static const Map<String, String> languageNames = {
    'en': 'English',
    'ja': '日本語',
    'zh': '中文',
  };
}

/// 편의를 위한 확장 함수
extension StringExtension on String {
  String get tr => AppStrings.get(this);
}
