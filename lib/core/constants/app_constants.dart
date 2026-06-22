/// Constantes globales de la aplicación.
/// Centraliza URLs base, rutas de navegación y valores por defecto.
class AppConstants {
  AppConstants._();

  // ── API ─────────────────────────────────────────────────────────────────────
  /// URL base del backend. Cambiar aquí para apuntar a producción/staging.
  static const String baseUrl = 'https://api.tu-isp.com';

  // ── Rutas de navegación (GoRouter) ───────────────────────────────────────────
  static const String routeHome = '/';
  static const String routeCheckHealth = '/check_health';
  static const String routeLoading = '/loading';
  static const String routeDiagnostico = '/diagnostico';
  static const String routeDiagnosticoResult = '/diagnostico_result';
  static const String routeChat = '/chat';
  static const String routeHistorial = '/historial';
  static const String routeGaming = '/gaming';
  static const String routeStreaming = '/streaming';
  static const String routeOffline = '/offline';
  static const String routeOfflineResult = '/offline_result';
  static const String routeChangePassword = '/change_password';
  static const String routeChangePasswordSuccess = '/change_password_success';
  static const String routeDispositivos = '/dispositivos';
  static const String routeAsistencia = '/asistencia';
  static const String routeAsistenciaDiagnostic = '/asistencia_diagnostic';
  static const String routeAsistenciaProblem = '/asistencia_problem';
  static const String routeAsistenciaSuccess = '/asistencia_success';
}
