import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router/app_router.dart';
import 'view/shared/app_colors.dart';
import 'data/sources/local/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa SharedPreferences antes de arrancar la app.
  // Necesario para que LocalStorage funcione de forma síncrona en toda la app.
  await LocalStorage.init();
  runApp(const ProviderScope(child: HealthCheckApp()));
}

class HealthCheckApp extends StatelessWidget {
  const HealthCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WiFi Speed',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
    );
  }
}
