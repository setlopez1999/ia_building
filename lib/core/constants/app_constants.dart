/// Constantes globales de la aplicación.
/// Centraliza URLs base, rutas de navegación y valores por defecto.
///
/// ── Cómo configurar la URL del backend ────────────────────────────────────────
///
/// Durante desarrollo (terminal):
///   fvm flutter run --dart-define=BASE_URL=https://api.mibackend.com
///
/// En VS Code — agregar en .vscode/launch.json:
///   {
///     "name": "Debug",
///     "request": "launch",
///     "type": "dart",
///     "args": ["--dart-define=BASE_URL=https://api.mibackend.com"]
///   }
///
/// En producción (build):
///   fvm flutter build apk --dart-define=BASE_URL=https://api.mibackend.com
///
/// Si no se pasa --dart-define, se usa el defaultValue definido abajo.
/// ─────────────────────────────────────────────────────────────────────────────
class AppConstants {
  AppConstants._();

  // ── API ─────────────────────────────────────────────────────────────────────

  /// URL base del backend, inyectada en tiempo de compilación vía --dart-define.
  /// Cambiar el defaultValue por la URL real cuando el backend esté disponible.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://serverpruebabryan.com.cd-latam.com',
  );

  /// Modo debug extendido: muestra logs de red completos en consola.
  /// Activar con: --dart-define=APP_DEBUG=true
  static const bool appDebug = bool.fromEnvironment(
    'APP_DEBUG',
    defaultValue: false,
  );

  // ── Branding (desde .env vía --dart-define-from-file) ─────────────────────────
  static const String colorGradient1 = String.fromEnvironment(
    'COLOR_GRADIENT_1',
    defaultValue: '#00CC66',
  );
  static const String colorGradient2 = String.fromEnvironment(
    'COLOR_GRADIENT_2',
    defaultValue: '#00BEB6',
  );
  static const String logoAsset = String.fromEnvironment(
    'LOGO_ASSET',
    defaultValue: 'assets/hub/logo_oneplay',
  );

  // ── Rutas de navegación (GoRouter) ───────────────────────────────────────────
  static const String routeLogin          = '/login';
  static const String routeHome           = '/';
  static const String routeCheckHealth    = '/check_health';
  static const String routeLoading        = '/loading';
  static const String routeHistorial      = '/historial';

  // Sub-rutas bajo /check_health/
  static const String routeDiagnostico        = '/check_health/diagnostico';
  static const String routeDiagnosticoResult  = '/check_health/diagnostico_result';
  static const String routeChat               = '/check_health/chat';
  static const String routeGaming             = '/check_health/gaming';
  static const String routeStreaming          = '/check_health/streaming';
  static const String routeOffline            = '/check_health/offline';
  static const String routeOfflineResult      = '/check_health/offline/result';
  static const String routeChangePassword     = '/check_health/change_password';
  static const String routeChangePasswordSuccess = '/check_health/change_password/success';
  static const String routeDispositivos       = '/check_health/dispositivos';
  static const String routeAsistencia         = '/check_health/asistencia';
  static const String routeAsistenciaDiagnostic = '/check_health/asistencia/diagnostic';
  static const String routeAsistenciaProblem  = '/check_health/asistencia/problem';
  static const String routeAsistenciaSuccess  = '/check_health/asistencia/success';
}
