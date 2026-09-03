import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/router/event_notification_router.dart';
import 'package:tvapp/config/router/router.dart';
import 'package:tvapp/config/theme/light.theme.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/services/alert_scheduler_service.dart';
import 'package:tvapp/core/services/fcm_service.dart';
import 'package:tvapp/core/services/notification_service.dart';
import 'package:tvapp/storage/tools/local_storage.dart';
import 'package:tvapp/ui/providers/connectivity/internet_check_provider.dart';
import 'package:tvapp/ui/providers/multicdn/multicdn_provider.dart';
import 'package:tvapp/ui/providers/notification/notifications_provider.dart';

import 'config/error_handler/error_handler.dart';


Future<void> main() async {
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await LocalStorage.init();
  await NotificationService.init(onTap: _handleNotificationTap);
  try { await FcmService.init(); } catch (_) {}
  try { AlertSchedulerService.start(); } catch (_) {}
  
  runApp(
    ProviderScope(
      observers: [
        ErrorHandler(),
      ],
      child: const _Initialization(
        child: MyApp()
      ),
    ),
  );
}

void _handleNotificationTap(Map<String, dynamic> payload) {
  final video = payload['video'] as String? ?? '';
  final serial = payload['serial'] as String? ?? '';
  if (video.isEmpty) return;
  final camera = CameraEntity(
    id: serial.isNotEmpty ? serial : 'movimiento',
    serial: serial,
    name: 'Movimiento detectado',
    isEvent: true,
    srt: '',
    hls: video,
  );
  // En cold start la app aun no tiene el router listo; encolamos y el
  // MainScreen consume la notificacion pendiente al montarse.
  EventNotificationRouter.queue(camera);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    EventNotificationRouter.tryOpen();
  });
}

class _Initialization extends ConsumerWidget {
  const _Initialization({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = [
      ref.watch(internetCheckProvider),
    ];

    if (values.every((value) => value.hasValue)) {
      return child;
    }

    return const SizedBox();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final router = ref.watch(appRouterProvider);
    ref.watch(multiCDNProvider);
    ref.watch(notificationsProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: Environment.appDebugMode,
      title: Environment.appName,
      theme: lightTheme,
    );
  }
}
