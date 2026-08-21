import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'i_tools_api_datasource.dart';

/// Cliente HTTP dedicado para los endpoints de herramientas de red (tools).
/// Lee el token JWT de la misma clave SharedPreferences que usa el auth de la app ('data').
class ToolsApiClient implements IToolsApiDatasource {
  static final ToolsApiClient _instance = ToolsApiClient._internal();
  factory ToolsApiClient() => _instance;
  ToolsApiClient._internal();

  late final Dio _dio;
  bool _initialized = false;

  Future<Dio> get dio async {
    if (!_initialized) await _init();
    return _dio;
  }

  Future<void> _init() async {
    final baseUrl = dotenv.env['TOOLS_BASE_URL'] ?? 'http://201.234.116.79:9090';
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (_) => true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    _initialized = true;
  }

  /// Obtiene el token desde la misma clave SharedPreferences que usa el auth de la app.
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('data');
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map['token'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    final d = await dio;
    final response = await d.get(path);
    if (response.statusCode == 401) throw Exception('Sesión expirada');
    if (response.statusCode != 200) throw Exception('Error ${response.statusCode}');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final d = await dio;
    final response = await d.post(path, data: body);
    if (response.statusCode == 401) throw Exception('Sesión expirada');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}');
    }
    return response.data as Map<String, dynamic>;
  }

  /// Como [post] pero retorna el body incluso en respuestas 4xx/5xx.
  /// Usar cuando el endpoint devuelve mensajes de error en el body.
  Future<Map<String, dynamic>> postForgiving(String path, {Map<String, dynamic>? body}) async {
    final d = await dio;
    final response = await d.post(path, data: body);
    return response.data as Map<String, dynamic>;
  }
}
