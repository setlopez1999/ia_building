import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/connectivity/internet_check_provider.dart';
import 'package:tvapp/ui/screens/account/account_screen.dart';
import 'package:tvapp/ui/screens/change_password/change_password_screen.dart';
import 'package:tvapp/ui/screens/channels/channels_screen.widget.dart';
import 'package:tvapp/ui/screens/family_filter/family_filter_code_sent_screen.dart';
import 'package:tvapp/ui/screens/family_filter/family_filter_screen.dart';
import 'package:tvapp/ui/screens/favorites/favorites.screen.dart';
import 'package:tvapp/ui/screens/guide/guide.screen.dart';
import 'package:tvapp/ui/screens/home/home.screen.dart';
import 'package:tvapp/ui/screens/initial_loader/initial_loader.screen.dart';
import 'package:tvapp/ui/screens/login/login.screen.dart';
import 'package:tvapp/ui/screens/main/main.screen.dart';
import 'package:tvapp/ui/screens/mascotas/mascotas_screen.dart';
import 'package:tvapp/ui/screens/no_internet/no_internet_screen.dart';
import 'package:tvapp/ui/screens/notification_detail/notification_detail_screen.dart';
import 'package:tvapp/ui/screens/notifications/notifications.screen.dart';
import 'package:tvapp/ui/screens/plan/plan_screen.dart';
import 'package:tvapp/ui/screens/player/player_screen.dart';
import 'package:tvapp/ui/screens/privacy_policies/privacy_policies.screen.dart';
import 'package:tvapp/ui/screens/products/associated_products_screen.dart';
import 'package:tvapp/ui/screens/products/product_detail_screen.dart';
import 'package:tvapp/ui/screens/profile/profile_screen.dart';
import 'package:tvapp/ui/screens/register/register-confirmation.screen.dart';
import 'package:tvapp/ui/screens/register/register.screen.dart';
import 'package:tvapp/ui/screens/search/search.screen.dart';
import 'package:tvapp/ui/screens/terms_and_conditions/terms_and_conditions.screen.dart';
import 'package:tvapp/ui/screens/tools/asistencia/asistencia_loading_screen.dart';
import 'package:tvapp/ui/screens/tools/cameras/cameras_screen.dart';
import 'package:tvapp/ui/screens/tools/cameras/player_camera_event_screen.dart';
import 'package:tvapp/ui/screens/tools/cameras/player_cameras_screen.dart';
import 'package:tvapp/ui/screens/tools/chat/chat_screen.dart';
import 'package:tvapp/ui/screens/tools/check_health/check_health_screen.dart';
import 'package:tvapp/ui/screens/tools/diagnostico/diagnostico_result_screen.dart';
import 'package:tvapp/ui/screens/tools/diagnostico/diagnostico_screen.dart';
import 'package:tvapp/ui/screens/tools/dispositivos/devices_screen.dart';
import 'package:tvapp/ui/screens/tools/gaming/gaming_detail_screen.dart';
import 'package:tvapp/ui/screens/tools/gaming/gaming_screen.dart';
import 'package:tvapp/ui/screens/tools/gaming/gaming_streaming_screen.dart';
import 'package:tvapp/ui/screens/tools/historial/historial_screen.dart';
import 'package:tvapp/ui/screens/tools/offline/offline_result_screen.dart';
import 'package:tvapp/ui/screens/tools/offline/offline_screen.dart';
import 'package:tvapp/ui/screens/tools/streaming/streaming_detail_screen.dart';
import 'package:tvapp/ui/screens/tools/streaming/streaming_screen.dart';
import 'package:tvapp/ui/screens/tools/wifi_password/wifi_password_screen.dart';

import 'navigation_service.dart';

part 'router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final routerKey = NavigationService.navigatorKey;

  ref..listen(internetCheckProvider, (previous, next) {
    if (next.hasValue) {
      final isConnected = next.value?.isConnected;

      if(isConnected != null && !isConnected) {
        // Esperar un frame para asegurar que el contexto esté disponible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = routerKey.currentContext;
          if (context != null) {
            GoRouter.of(context).replaceNamed(NoInternetScreen.name);
          }
        });
      }
    }
  })
  ..listen(authProvider, (previous, next) {
    next.whenOrNull(
      initial: () {
        routerKey.currentContext?.pushReplacementNamed(LoginScreen.name);
      },
      error: (AppException err) {
        routerKey.currentContext?.pushReplacementNamed(LoginScreen.name);
      }
    );
  });


  return GoRouter(
    navigatorKey: routerKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: InitialLoaderScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const InitialLoaderScreen();
        },
        pageBuilder: GoTransitions.cupertino.call
      ),

      GoRoute(
        path: '/no-internet',
        name: NoInternetScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const NoInternetScreen();
        },
        pageBuilder: GoTransitions.cupertino.call
      ),

      /// Login route
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (_, __) => const LoginScreen(),
          pageBuilder: GoTransitions.cupertino.call

      ),

      /// Register route
      GoRoute(
        path: '/register',
        name: RegisterScreen.name,
        builder: (_, __) => const RegisterScreen(),
          pageBuilder: GoTransitions.cupertino.call
      ),
      /// Register route
      GoRoute(
        path: '/register-confirmation',
        name: RegisterConfirmationScreen.name,
        builder: (_, __) => const RegisterConfirmationScreen(),
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Terms and conditions
      GoRoute(
        path: '/terms',
        name: TermsAndConditions.name,
        builder: (_, __) => const TermsAndConditions(),
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Privacy Policie
      GoRoute(
        path: '/policies',
        name: PrivacyPolicies.name,
        builder: (_, __) => const PrivacyPolicies(),
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Home route
      GoRoute(
        path: '/home',
        name: HomeScreen.name,
        builder: (_, __) => const HomeScreen(),
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Control Parental: confirmacion de codigo enviado.
      /// Ruta registrada pero OCULTA: todavia nadie navega hasta aca.
      GoRoute(
        path: FamilyFilterCodeSentScreen.path,
        name: FamilyFilterCodeSentScreen.name,
        builder: (_, __) => const FamilyFilterCodeSentScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),

      /// Mi cuenta: se llega desde el avatar del hub.
      GoRoute(
        path: '/account',
        name: MyAccountScreen.name,
        builder: (_, __) => const MyAccountScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),

      /// Otros productos asociados
      GoRoute(
        path: AssociatedProductsScreen.path,
        name: AssociatedProductsScreen.name,
        builder: (_, __) => const AssociatedProductsScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      GoRoute(
        path: ProductDetailScreen.path,
        name: ProductDetailScreen.name,
        builder: (_, __) => const ProductDetailScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),

      /// Mascotas: asistencia telefonica
      GoRoute(
        path: MascotasScreen.path,
        name: MascotasScreen.name,
        builder: (_, __) => const MascotasScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),

      /// Favorites route
      GoRoute(
        path: '/favorites',
        name: FavoritesScreen.name,
        builder: (_, __) => const FavoritesScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),

      /// Channels route - entrada directa del modulo IPTV desde el hub,
      /// sin pasar por el home antiguo ni por su barra inferior.
      GoRoute(
        path: '/channels',
        name: ChannelsScreen.name,
        builder: (_, __) => const ChannelsScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),

      /// Notifications route
      GoRoute(
        path: '/notifications',
        name: NotificationsScreen.name,
        builder: (_, __) => const NotificationsScreen(),
          pageBuilder: GoTransitions.cupertino.call
      ),

      GoRoute(
        path: '/notifications-detail',
        name: NotificationDetailScreen.name,
        builder: (_, __) => const NotificationDetailScreen(),
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Channels Details route
      GoRoute(
        path: '/player',
        name: PlayerScreen.name,
        builder: (_, __) => const PlayerScreen(),
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Search route
      GoRoute(
        path: '/search',
        name: SearchScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const SearchScreen();
        },
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Tv guide route
      GoRoute(
        path: '/tv-guide',
        name: GuideScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const GuideScreen();
        },
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Profile route
      GoRoute(
        path: '/profile',
        name: ProfileScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Plan route
      GoRoute(
        path: '/plan',
        name: PlanScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const PlanScreen();
        },
          pageBuilder: GoTransitions.cupertino.call
      ),

      /// Change password route
      GoRoute(
        path: '/change-password',
        name: ChangePasswordScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordScreen();
        },
          pageBuilder: GoTransitions.cupertino.call
      ),


      /// Main - Hub post-login
      GoRoute(
        path: MainScreen.path,
        name: MainScreen.name,
        builder: (_, __) => const MainScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Check Health
      GoRoute(
        path: '/tools/check-health',
        name: CheckHealthScreen.name,
        builder: (_, __) => const CheckHealthScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Diagnostico
      GoRoute(
        path: '/tools/diagnostico',
        name: DiagnosticoScreen.name,
        builder: (_, __) => const DiagnosticoScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Diagnostico Result
      GoRoute(
        path: '/check_health/diagnostico_result',
        name: DiagnosticoResultScreen.name,
        builder: (_, __) => const DiagnosticoResultScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Gaming
      GoRoute(
        path: '/tools/gaming',
        name: GamingScreen.name,
        builder: (_, __) => const GamingScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      GoRoute(
        path: '/tools/gaming/detail',
        name: GamingDetailScreen.name,
        builder: (_, state) {
          final server = state.extra as String? ?? '';
          return GamingDetailScreen(gameId: server);
        },
        pageBuilder: GoTransitions.cupertino.call,
      ),
      GoRoute(
        path: '/tools/gaming/streaming',
        name: GamingStreamingScreen.name,
        builder: (_, __) => const GamingStreamingScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Streaming
      GoRoute(
        path: '/tools/streaming',
        name: StreamingScreen.name,
        builder: (_, __) => const StreamingScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      GoRoute(
        path: '/tools/streaming/detail',
        name: StreamingDetailScreen.name,
        builder: (_, state) {
          final platformId = state.extra as String? ?? '';
          return StreamingDetailScreen(platformId: platformId);
        },
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Chat
      GoRoute(
        path: '/tools/chat',
        name: ChatScreen.name,
        builder: (_, __) => const ChatScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Dispositivos
      GoRoute(
        path: '/tools/devices',
        name: DevicesScreen.name,
        builder: (_, __) => const DevicesScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Offline
      GoRoute(
        path: '/tools/offline',
        name: OfflineScreen.name,
        builder: (_, __) => const OfflineScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Asistencia
      GoRoute(
        path: '/tools/asistencia',
        name: AsistenciaLoadingScreen.name,
        builder: (_, __) => const AsistenciaLoadingScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Historial
      GoRoute(
        path: HistorialScreen.path,
        name: HistorialScreen.name,
        builder: (_, __) => const HistorialScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Offline Result
      GoRoute(
        path: '/tools/offline/result',
        name: OfflineResultScreen.name,
        builder: (_, state) {
          final type = state.extra as String? ?? 'all';
          return OfflineResultScreen(type: type);
        },
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Wifi Password
      GoRoute(
        path: WifiPasswordScreen.path,
        name: WifiPasswordScreen.name,
        builder: (_, state) {
          final ssid = state.extra as String? ?? '';
          return WifiPasswordScreen(ssid: ssid);
        },
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Cameras list
      GoRoute(
        path: '/tools/cameras',
        name: CamerasScreen.name,
        builder: (_, __) => const CamerasScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Camera player (SRT)
      GoRoute(
        path: '/tools/cameras/player',
        name: PlayerCamerasScreen.name,
        builder: (_, __) => const PlayerCamerasScreen(),
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Tools: Camera event player (HLS)
      GoRoute(
        path: '/tools/cameras/event-player',
        name: PlayerCameraEventScreen.name,
        builder: (_, state) {
          final stream = state.extra as CameraEntity;
          return PlayerCameraEventScreen(stream: stream);
        },
        pageBuilder: GoTransitions.cupertino.call,
      ),
      /// Filter family route
      GoRoute(
        path: '/family-filter',
        name: FamilyFilterScreen.name,
        builder: (BuildContext context, GoRouterState state) {
          return const FamilyFilterScreen();
        },
          pageBuilder: GoTransitions.cupertino.call
      ),
    ],
  );
}
