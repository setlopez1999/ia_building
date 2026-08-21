import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/config/router/navigation_service.dart';

/// Cola de navegación para abrir el reproductor de evento de movimiento
/// cuando la app arranca desde una notificación (cold start).
class EventNotificationRouter {
  static CameraEntity? _pendingCamera;

  static bool get hasPending => _pendingCamera != null;

  static void queue(CameraEntity camera) {
    _pendingCamera = camera;
  }

  static void tryOpen() {
    final camera = _pendingCamera;
    if (camera == null) return;
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    // En cold start la ruta base es '/' (InitialLoader) o '/login'.
    // No abrir el reproductor encima: solo se consume cuando la app
    // ya está en la pantalla principal (Main), evitando que el back
    // caiga en el InitialLoader (carga infinita).
    final path = GoRouter.of(context).state.uri.path;
    if (path == '/' || path == '/login' || path == '/no-internet') {
      return;
    }

    _pendingCamera = null;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    context.push('/tools/cameras/event-player', extra: camera);
  }

  static void clear() {
    _pendingCamera = null;
  }
}
