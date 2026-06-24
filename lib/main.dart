import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/router/router_provider.dart';
import 'core/theme/app_colors.dart';
import 'shared/data/local/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  final router = appRouter;
  runApp(
    ProviderScope(
      overrides: [goRouterProvider.overrideWithValue(router)],
      child: const HealthCheckApp(),
    ),
  );
}

class HealthCheckApp extends ConsumerWidget {
  const HealthCheckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'WiFi Speed',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
    );
  }
}
