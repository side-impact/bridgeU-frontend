/// 앱 전체에서 사용하는 상수들
class AppConstants {
  static const String appName = 'BridgeU';
  static const String appVersion = '1.0.0';

  static const List<String> supportedLanguages = ['en', 'ja', 'zh'];
  
  // 지원 학교 (SKY)
  static const List<String> supportedSchools = ['S', 'K', 'Y'];
  static const Map<String, String> schoolNames = {
    'S': 'Seoul National University',
    'K': 'Korea University', 
    'Y': 'Yonsei University',
  };

  // 커뮤니티 태그
  static const List<String> communityTags = [
    'transportation',    // 교통
    'convenience_store', // 편의점
    'laundromat',       // 빨래방
    'kiosk',            // 키오스크
    'safety',           // 안전
    'housing',          // 주거
    'food',             // 음식
    'daily_life',       // 일상생활
    'school',           // 학교
    'part_time_job',    // 아르바이트
    'restaurant',       // 맛집
  ];

  // API 관련
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryCount = 3;

  // 페이징
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // 파일 업로드
  static const int maxImageSizeMB = 10;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];

  // 번역 관련
  static const Map<String, String> translateLanguageCodes = {
    'en': 'en',
    'ja': 'ja', 
    'zh': 'zh-CN',
    'ko': 'ko',
  };
}

/// 라우트 상수
// class Routes {
//   static const String login = '/login';
//   static const String home = '/home';
//   static const String community = '/community';
//   static const String translate = '/translate';
//   static const String chatbot = '/chatbot';
//   static const String settings = '/settings';
// }

/// 에러 메시지 상수
class ErrorMessages {
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unauthorized = 'Authentication required';
  static const String forbidden = 'Access denied';
  static const String notFound = 'Resource not found';
  static const String validationError = 'Invalid input data';
}
