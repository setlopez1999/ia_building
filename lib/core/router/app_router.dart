import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── Shell ─────────────────────────────────────────────────────────────────────
import '../theme/app_shell.dart';

// ── Auth ──────────────────────────────────────────────────────────────────────
import '../../features/auth/presentation/login_screen.dart';

// ── Tab: Inicio ───────────────────────────────────────────────────────────────
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/service_loading_screen.dart';

// ── Tab: Check Health ─────────────────────────────────────────────────────────
import '../../features/check_health/presentation/check_health_screen.dart';
import '../../features/diagnostico/presentation/diagnostico_screen.dart';
import '../../features/diagnostico/presentation/diagnostico_result_screen.dart';
import '../../features/dispositivos/presentation/devices_screen.dart';
import '../../features/offline/presentation/offline_screen.dart';
import '../../features/offline/presentation/offline_result_screen.dart';
import '../../features/asistencia/presentation/asistencia_intro_screen.dart';
import '../../features/asistencia/presentation/asistencia_loading_screen.dart';
import '../../features/asistencia/presentation/asistencia_problem_screen.dart';
import '../../features/asistencia/presentation/asistencia_success_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/gaming/presentation/gaming_screen.dart';
import '../../features/gaming/presentation/gaming_detail_screen.dart';
import '../../features/gaming/presentation/gaming_streaming_screen.dart';
import '../../features/streaming/presentation/streaming_screen.dart';
import '../../features/streaming/presentation/streaming_detail_screen.dart';
import '../../features/change_password/presentation/change_password_screen.dart';
import '../../features/change_password/presentation/change_password_success_screen.dart';

// ── Tab: Historial ────────────────────────────────────────────────────────────
import '../../features/historial/presentation/historial_screen.dart';

// ── Infraestructura ───────────────────────────────────────────────────────────
import '../../shared/data/local/local_storage.dart';

const _publicRoutes = {'/login'};

final appRouterProvider = Provider<GoRouter>((ref) => _buildRouter());

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: false,

    redirect: (context, state) {
      final isLoggedIn = LocalStorage.getToken() != null;
      final isPublic = _publicRoutes.contains(state.matchedLocation);
      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && isPublic) return '/';
      return null;
    },

    routes: [
      // ── Login ─────────────────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Loading de servicio ────────────────────────────────────────────────
      GoRoute(
        path: '/loading',
        builder: (context, state) {
          final to = state.uri.queryParameters['to'] ?? '/';
          return ServiceLoadingScreen(targetPath: to);
        },
      ),

      // ── Shell con BottomNavigationBar ──────────────────────────────────────
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
                    builder: (context, state) => const DiagnosticoResultScreen(),
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
                        builder: (context, state) => const OfflineResultScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'asistencia',
                    builder: (context, state) => const AsistenciaIntroScreen(),
                    routes: [
                      GoRoute(
                        path: 'diagnostic',
                        builder: (context, state) => const AsistenciaLoadingScreen(),
                      ),
                      GoRoute(
                        path: 'problem',
                        builder: (context, state) => const AsistenciaProblemScreen(),
                      ),
                      GoRoute(
                        path: 'success',
                        builder: (context, state) => const AsistenciaSuccessScreen(),
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
                        builder: (context, state) => const GamingStreamingScreen(),
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
                    builder: (context, state) => const ChangePasswordScreen(),
                    routes: [
                      GoRoute(
                        path: 'success',
                        builder: (context, state) => const ChangePasswordSuccessScreen(),
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

final appRouter = _buildRouter();
