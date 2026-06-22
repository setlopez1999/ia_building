import 'package:go_router/go_router.dart';

// ── Vistas (nueva estructura view/screens/) ───────────────────────────────────
import '../../view/screens/home/home_screen.dart';
import '../../view/screens/home/service_loading_screen.dart';
import '../../view/screens/check_health/check_health_screen.dart';
import '../../view/screens/diagnostico/diagnostico_screen.dart';
import '../../view/screens/diagnostico/diagnostico_result_screen.dart';
import '../../view/screens/historial/historial_screen.dart';
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

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/check_health',
      builder: (context, state) => const CheckHealthScreen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) {
        final to = state.uri.queryParameters['to'] ?? '/';
        return ServiceLoadingScreen(targetPath: to);
      },
    ),
    GoRoute(
      path: '/diagnostico',
      builder: (context, state) => const DiagnosticoScreen(),
    ),
    GoRoute(
      path: '/diagnostico_result',
      builder: (context, state) => const DiagnosticoResultScreen(),
    ),
    GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
    GoRoute(
      path: '/historial',
      builder: (context, state) => const HistorialScreen(),
    ),
    GoRoute(
      path: '/gaming',
      builder: (context, state) => const GamingScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              GamingDetailScreen(gameId: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      path: '/streaming',
      builder: (context, state) => const StreamingScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              StreamingDetailScreen(platformId: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      path: '/offline',
      builder: (context, state) => const OfflineScreen(),
    ),
    GoRoute(
      path: '/offline_result',
      builder: (context, state) => const OfflineResultScreen(),
    ),
    GoRoute(
      path: '/change_password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/change_password_success',
      builder: (context, state) => const ChangePasswordSuccessScreen(),
    ),
    GoRoute(
      path: '/dispositivos',
      builder: (context, state) => const DevicesScreen(),
    ),
    GoRoute(
      path: '/asistencia',
      builder: (context, state) => const AsistenciaIntroScreen(),
    ),
    GoRoute(
      path: '/asistencia_diagnostic',
      builder: (context, state) => const AsistenciaLoadingScreen(),
    ),
    GoRoute(
      path: '/gaming_streaming',
      builder: (context, state) => const GamingStreamingScreen(),
    ),
    GoRoute(
      path: '/asistencia_problem',
      builder: (context, state) => const AsistenciaProblemScreen(),
    ),
    GoRoute(
      path: '/asistencia_success',
      builder: (context, state) => const AsistenciaSuccessScreen(),
    ),
  ],
);
