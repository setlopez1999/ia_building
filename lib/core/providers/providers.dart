import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/local_device_service.dart';
import '../../data/sources/remote/api_client.dart';
import '../../data/sources/local/local_storage.dart';

// ── Repositorios (interfaces) ────────────────────────────────────────────────
import '../../data/repositories/interfaces/auth_repository.dart';
import '../../data/repositories/interfaces/config_repository.dart';
import '../../data/repositories/interfaces/perfil_repository.dart';
import '../../data/repositories/interfaces/notificacion_repository.dart';
import '../../data/repositories/interfaces/diagnostico_repository.dart';
import '../../data/repositories/interfaces/fibra_repository.dart';
import '../../data/repositories/interfaces/wifi_repository.dart';
import '../../data/repositories/interfaces/dispositivo_repository.dart';
import '../../data/repositories/interfaces/gaming_repository.dart';

// ── Implementaciones ─────────────────────────────────────────────────────────
import '../../data/repositories/impl/auth_repository_impl.dart';
import '../../data/repositories/impl/config_repository_impl.dart';
import '../../data/repositories/impl/perfil_repository_impl.dart';
import '../../data/repositories/impl/notificacion_repository_impl.dart';
import '../../data/repositories/impl/diagnostico_repository_impl.dart';
import '../../data/repositories/impl/fibra_repository_impl.dart';
import '../../data/repositories/impl/wifi_repository_impl.dart';
import '../../data/repositories/impl/dispositivo_repository_impl.dart';
import '../../data/repositories/impl/gaming_repository_impl.dart';

// ── Modelos ───────────────────────────────────────────────────────────────────
import '../../data/models/user.dart';
import '../../data/models/notificacion.dart';
import '../../data/models/diagnostico.dart';
import '../../data/models/fibra.dart';
import '../../data/models/dispositivo.dart';
import '../../data/models/servidor_juego.dart';
import '../../data/models/app_config.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// INFRAESTRUCTURA
// ═══════════════════════════════════════════════════════════════════════════════

/// Cliente HTTP global. Todos los repositorios lo consumen.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: AppConstants.baseUrl);
});

// ═══════════════════════════════════════════════════════════════════════════════
// REPOSITORIOS
// ═══════════════════════════════════════════════════════════════════════════════

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(apiClientProvider));
});

final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  return ConfigRepositoryImpl(ref.read(apiClientProvider));
});

final perfilRepositoryProvider = Provider<PerfilRepository>((ref) {
  return PerfilRepositoryImpl(ref.read(apiClientProvider));
});

final notificacionRepositoryProvider = Provider<NotificacionRepository>((ref) {
  return NotificacionRepositoryImpl(ref.read(apiClientProvider));
});

final diagnosticoRepositoryProvider = Provider<DiagnosticoRepository>((ref) {
  return DiagnosticoRepositoryImpl(ref.read(apiClientProvider));
});

final fibraRepositoryProvider = Provider<FibraRepository>((ref) {
  return FibraRepositoryImpl(ref.read(apiClientProvider));
});

final wifiRepositoryProvider = Provider<WifiRepository>((ref) {
  return WifiRepositoryImpl(ref.read(apiClientProvider));
});

final dispositivoRepositoryProvider = Provider<DispositivoRepository>((ref) {
  return DispositivoRepositoryImpl(ref.read(apiClientProvider));
});

/// GamingRepositoryImpl expone tanto IGamingRepository como el stream local.
final gamingRepositoryImplProvider = Provider<GamingRepositoryImpl>((ref) {
  final repo = GamingRepositoryImpl(ref.read(apiClientProvider));
  ref.onDispose(repo.dispose);
  return repo;
});

final gamingRepositoryProvider = Provider<IGamingRepository>((ref) {
  return ref.read(gamingRepositoryImplProvider);
});

// ═══════════════════════════════════════════════════════════════════════════════
// PROVIDERS DE ESTADO (AsyncNotifier / FutureProvider)
// ═══════════════════════════════════════════════════════════════════════════════

// ── Auth ─────────────────────────────────────────────────────────────────────

/// Estado de sesión: true si hay token válido en SharedPreferences.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return LocalStorage.getToken() != null;
});

// ── Config ────────────────────────────────────────────────────────────────────

/// Carga la configuración del backend al iniciar la app.
/// Aplica lógica cache-first de assets y guarda networkTargets.
final appConfigProvider = FutureProvider<AppConfig>((ref) async {
  return ref.read(configRepositoryProvider).getConfig();
});

// ── Perfil ────────────────────────────────────────────────────────────────────

/// Datos del usuario autenticado. Se carga al iniciar HomeScreen.
/// Fuente: GET /v1/user/profile  (PERFIL-1)
final perfilProvider = FutureProvider<User>((ref) async {
  return ref.read(perfilRepositoryProvider).getProfile();
});

// ── Notificaciones ────────────────────────────────────────────────────────────

/// Lista de notificaciones del ISP.
/// Fuente: GET /v1/notifications  (NOTIF-1)
final notificacionesProvider = FutureProvider<List<Notificacion>>((ref) async {
  return ref.read(notificacionRepositoryProvider).getNotificaciones();
});

/// Cantidad de notificaciones no leídas (badge).
final notificacionesNoLeidasProvider = Provider<int>((ref) {
  return ref.watch(notificacionesProvider).maybeWhen(
        data: (list) => list.where((n) => !n.leido).length,
        orElse: () => 0,
      );
});

// ── Diagnóstico ───────────────────────────────────────────────────────────────

/// Historial de diagnósticos del cliente.
/// Fuente: GET /v1/diagnosticos  (DIAG-2)
final historialDiagnosticoProvider =
    FutureProvider<List<Diagnostico>>((ref) async {
  return ref.read(diagnosticoRepositoryProvider).getHistorial();
});

// ── Fibra ─────────────────────────────────────────────────────────────────────

/// Estado de fibra óptica.
/// Fuente: GET /v1/fibra  (FIBRA-1)
final fibraProvider = FutureProvider<Fibra>((ref) async {
  return ref.read(fibraRepositoryProvider).getFibra();
});

// ── Dispositivos ──────────────────────────────────────────────────────────────

/// Dispositivos conectados a la red local, escaneados desde el teléfono vía ARP.
/// Fallback al backend mock si el escaneo local falla.
final dispositivosProvider = FutureProvider<List<Dispositivo>>((ref) async {
  try {
    final localDevices =
        await ref.read(localDeviceServiceProvider).scanLocalDevices();
    if (localDevices.isNotEmpty) return localDevices;
  } catch (_) {}
  return ref.read(dispositivoRepositoryProvider).getDispositivos();
});

// ── Gaming ────────────────────────────────────────────────────────────────────

/// Servidores de juegos con métricas de red.
/// Fuente: GET /v1/gaming/servers  (GAMING-1)
final servidoresJuegoProvider =
    FutureProvider<List<ServidorJuego>>((ref) async {
  return ref.read(gamingRepositoryProvider).getServidores();
});

/// Stream en tiempo real de métricas de gaming (actualizado por GamingMonitorService).
final servidoresJuegoStreamProvider =
    StreamProvider<List<ServidorJuego>>((ref) {
  return ref.read(gamingRepositoryImplProvider).watchServidores();
});
