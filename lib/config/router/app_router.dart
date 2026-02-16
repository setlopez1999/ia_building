import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';
import '../../screens/chat_screen.dart';
import '../../screens/history_screen.dart';
import '../../screens/diagnostico_screen.dart';
import '../../screens/diagnostico_result_screen.dart';
import '../../screens/gaming_streaming_screen.dart';
import '../../screens/offline_screen.dart';
import '../../screens/offline_result_screen.dart';
import '../../screens/change_password_screen.dart';
import '../../screens/change_password_success_screen.dart';
import '../../screens/devices_screen.dart';
import '../../screens/asistencia_intro_screen.dart';
import '../../screens/asistencia_screen.dart';
import '../../screens/asistencia_problem_screen.dart';
import '../../screens/asistencia_success_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/gaming',
      builder: (context, state) => const GamingStreamingScreen(),
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
      builder: (context, state) => const AsistenciaScreen(),
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
