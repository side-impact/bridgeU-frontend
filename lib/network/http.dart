import 'package:dio/dio.dart';
import '../config/env.dart';
//import '../storage/secure_storage.dart';
import 'api_error.dart';

//기본 코드인데 이건 로그인-토큰 방식일 경우라 세션이면 바꿔주세요!
final dio = Dio(BaseOptions(baseUrl: Env.apiBase))
  ..interceptors.add(InterceptorsWrapper(
    // 자동 토큰 넣기 : 로그인 후 모든 API 호출에 인증 토큰.
    onRequest: (options, handler) async {
      final token = await Secure.store.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (e, handler) async {
      handler.next(ApiError.intercept(e));
    },
  ));