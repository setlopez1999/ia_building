import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tvapp/core/infraestructure/datasource/session_token_source.dart';
import 'i_tools_api_datasource.dart';

/// Cliente HTTP de los endpoints de herramientas de red (Check Health).
///
/// Usa **la misma sesión que el resto de la app**: el token de `/api/inicio`,
/// pedido a [SessionTokenSource]. No es un token JWT ni un login aparte; ese
/// comentario era incorrecto y confundía dos sistemas distintos.
///
/// ⚠️ El token vale **solo contra el servidor que lo emitió** (`BASE_HOST`).
/// Mientras `TOOLS_BASE_URL` apunte a un servidor distinto —hoy el de pruebas,
/// porque el backend de herramientas todavía no migró a producción— estas
/// llamadas van a responder 401. Eso no es un fallo de la app: es que el
/// módulo apunta a un servidor donde esta sesión no existe.
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

  /// Fuente única de la sesión. Ver [SessionTokenSource].
  Future<String?> _getToken() => SessionTokenSource().token();

  Future<Map<String, dynamic>> get(String path) async {
    final d = await dio;
    final response = await d.get(path);
    _verificar(response, path);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final d = await dio;
    final response = await d.post(path, data: body);
    _verificar(response, path, aceptaCreado: true);
    return response.data as Map<String, dynamic>;
  }

  /// Traduce la respuesta a un error que la UI pueda mostrar.
  ///
  /// El 401 casi nunca significa "el usuario cerró sesión": significa que este
  /// servidor no reconoce la sesión de la app. Decirlo así ahorra horas de
  /// buscar el problema en el lado equivocado.
  void _verificar(Response<dynamic> response, String path,
      {bool aceptaCreado = false}) {
    final code = response.statusCode ?? 0;
    if (code == 200 || (aceptaCreado && code == 201)) return;

    if (code == 401) {
      throw ToolsUnavailableException(
        'El servicio no está disponible para tu cuenta en este momento.',
        detail: 'GET/POST $path → HTTP 401\n'
            'El servidor de herramientas (TOOLS_BASE_URL) no reconoce la '
            'sesión emitida por BASE_HOST. Los dos apuntan a servidores '
            'distintos.',
      );
    }

    throw ToolsUnavailableException(
      'No se pudo completar la operación. Intenta nuevamente.',
      detail: '$path → HTTP $code\n${response.data}',
    );
  }

  /// Como [post] pero retorna el body incluso en respuestas 4xx/5xx.
  /// Usar cuando el endpoint devuelve mensajes de error en el body.
  Future<Map<String, dynamic>> postForgiving(String path, {Map<String, dynamic>? body}) async {
    final d = await dio;
    final response = await d.post(path, data: body);
    return response.data as Map<String, dynamic>;
  }
}

/// Error del módulo de herramientas, con detalle técnico separado del mensaje
/// que ve el usuario (Regla 1.b de docs/REGLAS.md).
class ToolsUnavailableException implements Exception {
  ToolsUnavailableException(this.message, {this.detail});

  final String message;
  final String? detail;

  @override
  String toString() => message;
}
