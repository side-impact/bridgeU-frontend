import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../utils/navigation.dart'; // navigatorKey 사용을 위해

const String baseUrl = "http://localhost:8080";

// Dio 인스턴스 생성 및 전역 인터셉터 설정
final dio = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
))..interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final path = options.path;
      
      // /api/** 경로에만 JWT 토큰 자동 추가 (백엔드 정책과 일치)
      // /auth/** 경로는 제외 (로그인/회원가입)
      if (path.startsWith('/api/') && !path.startsWith('/auth/')) {
        final token = await _getStoredToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          print('JWT 토큰 자동 추가: ${path}');
        } else {
          print('JWT 토큰이 없음: ${path}');
        }
      }
      
      handler.next(options);
    },
    
    onError: (error, handler) async {
      print('API 에러: ${error.response?.statusCode} - ${error.requestOptions.path}');
      
      // 401 Unauthorized: 토큰 만료 또는 무효
      if (error.response?.statusCode == 401) {
        print('토큰 만료 또는 무효 - 자동 로그아웃 처리');
        await _handleTokenExpired();
      }
      
      // 403 Forbidden: 권한 없음
      if (error.response?.statusCode == 403) {
        print('권한 없음 - ${error.requestOptions.path}');
      }
      
      handler.next(error);
    },
  ),
);

/// SharedPreferences에서 JWT 토큰 가져오기
Future<String?> _getStoredToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwtToken");
  } catch (e) {
    print('토큰 로드 실패: $e');
    return null;
  }
}

/// 토큰 만료 시 자동 로그아웃 처리
Future<void> _handleTokenExpired() async {
  try {
    // SharedPreferences에서 토큰 제거
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwtToken");
    
    // 로그인 화면으로 자동 이동 (모든 이전 화면 제거)
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    
    print('자동 로그아웃 완료 - 로그인 화면으로 이동');
  } catch (e) {
    print('자동 로그아웃 실패: $e');
  }
}