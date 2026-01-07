import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  AuthService._();

  static const _kToken = 'token';
  static const _kUsername = 'username';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiService.baseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<void> login(String username, String password) async {
    try {
      final res = await _dio.post(
        '/api/auth/login',
        data: {"username": username, "password": password},
      );

      final token = (res.data is Map && res.data['token'] != null)
          ? res.data['token'].toString()
          : 'ok'; // Token yoksa bile login oldu say
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_kToken, token);
      await sp.setString(_kUsername, username);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data?.toString() ?? e.message ?? 'Login hata';
      throw Exception("Login failed ($status): $msg");
    }
  }

  static Future<void> register(String username, String password) async {
    try {
      await _dio.post(
        '/api/auth/register',
        data: {"username": username, "password": password},
      );
      // kayıt sonrası otomatik login isteğe bağlı; ben zorlamıyorum.
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data?.toString() ?? e.message ?? 'Register hata';
      throw Exception("Register failed ($status): $msg");
    }
  }

  static Future<String?> getUsername() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUsername);
  }

  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kToken);
    await sp.remove(_kUsername);
  }
}