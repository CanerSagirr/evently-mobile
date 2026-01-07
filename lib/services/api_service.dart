import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/event.dart';

class ApiService {
  ApiService._();

  static String get baseUrl {
    // Web tarayıcı host makineyi görür
    if (kIsWeb) return "http://localhost:5062";

    // Android emulator host makineye 10.0.2.2 ile gider
    if (Platform.isAndroid) return "http://10.0.2.2:5062";

    // Windows desktop / diğerleri
    return "http://127.0.0.1:5062";
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<List<EventModel>> getEvents() async {
    final res = await dio.get('/api/events');
    final data = res.data;

    final List rawList = (data is List)
        ? data
        : (data is Map && data['items'] is List)
            ? data['items'] as List
            : <dynamic>[];

    return rawList
        .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}