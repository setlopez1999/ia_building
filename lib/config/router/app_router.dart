import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── Shell ─────────────────────────────────────────────────────────────────────
import '../../view/shared/app_shell.dart';

// ── Auth ──────────────────────────────────────────────────────────────────────
import '../../view/screens/auth/login_screen.dart';

// ── Tabs principales (ShellRoute) ─────────────────────────────────────────────
import '../../view/screens/home/home_screen.dart';
import '../../view/screens/check_health/check_health_screen.dart';
import '../../view/screens/historial/historial_screen.dart';

// ── Sub-rutas (sin BottomNav) ─────────────────────────────────────────────────
import '../../view/screens/home/service_loading_screen.dart';
import '../../view/screens/diagnostico/diagnostico_screen.dart';
import '../../view/screens/diagnostico/diagnostico_result_screen.dart';
import '../../view/screens/gaming/gaming_screen.dart';
import '../../view/screens/gaming/gaming_detail_screen.dart';
import '../../view/screens/gaming/gaming_streaming_screen.dart';
import '../../view/screens/streaming/streaming_screen.dart';
import '../../view/screens/streaming/streaming_detail_screen.dart';
import '../../view/screens/chat/chat_screen.dart';
import '../../view/screens/asistencia/asistencia_intro_screen.dart';
import '../../view/screens/asistencia/asistencia_loading_screen.dart';
import '../../view/screens/asistencia/asistencia_problem_screen.dart';
import '../../view/screens/asistencia/asistencia_success_screen.dart';
import '../../view/screens/offline/offline_screen.dart';
import '../../view/screens/offline/offline_result_screen.dart';
import '../../view/screens/change_password/change_password_screen.dart';
import '../../view/screens/change_password/change_password_success_screen.dart';
import '../../view/screens/devices/devices_screen.dart';
import '../../data/sources/local/local_storage.dart';

// ── Rutas públicas (sin auth) ─────────────────────────────────────────────────
const _publicRoutes = {'/login'};

/// Provider del router para poder escuchar cambios de auth y refrescar el guard.
final appRouterProvider = Provider<GoRouter>((ref) {
  return _buildRouter();
});

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: false,

    // ── Guard de autenticación ────────────────────────────────────────────────
    redirect: (context, state) {
      final isLoggedIn = LocalStorage.getToken() != null;
      final isPublic = _publicRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && isPublic) return '/';
      return null;
    },

    routes: [
      // ── Login (fuera del shell) ─────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Loading (fuera del shell, ruta de transición) ─────────────────────────
      GoRoute(
        path: '/loading',
        builder: (context, state) {
          final to = state.uri.queryParameters['to'] ?? '/';
          return ServiceLoadingScreen(targetPath: to);
        },
      ),

      // ── Shell con BottomNavigationBar ───────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Tab 0 — Inicio
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Tab 1 — Check Health
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/check_health',
                builder: (context, state) => const CheckHealthScreen(),
                routes: [
                  GoRoute(
                    path: 'diagnostico',
                    builder: (context, state) => const DiagnosticoScreen(),
                  ),
                  GoRoute(
                    path: 'diagnostico_result',
                    builder: (context, state) =>
                        const DiagnosticoResultScreen(),
                  ),
                  GoRoute(
                    path: 'dispositivos',
                    builder: (context, state) => const DevicesScreen(),
                  ),
                  GoRoute(
                    path: 'offline',
                    builder: (context, state) => const OfflineScreen(),
                    routes: [
                      GoRoute(
                        path: 'result',
                        builder: (context, state) =>
                            const OfflineResultScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'asistencia',
                    builder: (context, state) =>
                        const AsistenciaIntroScreen(),
                    routes: [
                      GoRoute(
                        path: 'diagnostic',
                        builder: (context, state) =>
                            const AsistenciaLoadingScreen(),
                      ),
                      GoRoute(
                        path: 'problem',
                        builder: (context, state) =>
                            const AsistenciaProblemScreen(),
                      ),
                      GoRoute(
                        path: 'success',
                        builder: (context, state) =>
                            const AsistenciaSuccessScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'chat',
                    builder: (context, state) => const ChatScreen(),
                  ),
                  GoRoute(
                    path: 'gaming',
                    builder: (context, state) => const GamingScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) => GamingDetailScreen(
                          gameId: state.pathParameters['id']!,
                        ),
                      ),
                      GoRoute(
                        path: 'streaming_mode',
                        builder: (context, state) =>
                            const GamingStreamingScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'streaming',
                    builder: (context, state) => const StreamingScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) => StreamingDetailScreen(
                          platformId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'change_password',
                    builder: (context, state) =>
                        const ChangePasswordScreen(),
                    routes: [
                      GoRoute(
                        path: 'success',
                        builder: (context, state) =>
                            const ChangePasswordSuccessScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Tab 2 — Historial
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/historial',
                builder: (context, state) => const HistorialScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// ── Router global (para usar en MaterialApp.router sin Riverpod) ──────────────
final appRouter = _buildRouter();
