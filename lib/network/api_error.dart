//에러 처리 코드.
import 'package:dio/dio.dart';

class ApiError implements Exception {
  final String code;
  final String message;
  final int? status;

  ApiError(this.code, this.message, {this.status});

  static ApiError intercept(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      final code = (data is Map && data['code'] is String) ? data['code'] as String : 'HTTP_${e.response!.statusCode}';
      final msg  = (data is Map && data['message'] is String) ? data['message'] as String : (e.message ?? 'Network error');
      return ApiError(code, msg, status: e.response?.statusCode);
    }
    return ApiError('NETWORK', e.message ?? 'Network error');
  }

  @override
  String toString() => '[$code] $message';
}
