import 'package:dio/dio.dart';
//다국어 지원하려면 에러 메시지들을 따로 string 파일로 관리하기 (현재는 영어만만)
class TranslateService {
  static const String baseUrl = 'http://localhost:8080/api'; //나중에 확정나면 한번에 관리!
  late final Dio _dio;
  
  TranslateService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }

  /// 번역 API
  Future<String> translate({
    required String sourceText,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
      final response = await _dio.post('/translate', data: {
        'sourceText': sourceText,
        'sourceLang': sourceLang,
        'targetLang': targetLang,
      });

      if (response.statusCode == 200 && response.data != null) {
        final apiResponseData = response.data['data'];
        if (apiResponseData != null && apiResponseData['translatedText'] != null) {
          return apiResponseData['translatedText'];
        } else {
          throw Exception('Invalid response structure: missing translatedText');
        }
      } else {
        throw Exception('Failed to get a proper translation response.');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your network connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Response timeout. The server is taking too long to respond.');
      } else if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['message'] != null) {
          throw Exception('Translation error: ${errorData['message']}');
        } else {
          throw Exception('Server error (${e.response?.statusCode}). Please try again later.');
        }
      } else {
        throw Exception('Network error. Please check your internet connection.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred. Please try again later.');
    }
  }
}
