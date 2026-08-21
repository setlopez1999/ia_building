import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/domain/entities/tools/camera_event_entity.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/camera_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/camera_repository_impl.dart';
import 'package:tvapp/storage/tools/local_storage.dart';

final cameraRepositoryProvider = Provider<CameraRepository>((ref) {
  return CameraRepositoryImpl();
});

final cameraListProvider = FutureProvider<List<CameraEntity>>((ref) async {
  final timer = Timer.periodic(const Duration(seconds: 15), (_) {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);
  final clienteId = LocalStorage.getClienteId();
  if (clienteId == null || clienteId.isEmpty) {
    throw Exception('clienteId no disponible');
  }
  return ref.watch(cameraRepositoryProvider).getCameras(clienteId: clienteId);
});

final cameraEventsProvider =
    FutureProvider.family<List<CameraEventEntity>, String>((ref, motionLogUrl) async {
  return ref.watch(cameraRepositoryProvider).getCameraEvents(motionLogUrl);
});

final cameraAlertEventsProvider =
    FutureProvider.family<List<CameraEventEntity>, String>((ref, motionLogUrl) async {
  final timer = Timer.periodic(const Duration(seconds: 15), (_) {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);
  return ref.watch(cameraRepositoryProvider).getCameraEvents(motionLogUrl);
});

final cameraSelectedProvider =
    NotifierProvider<CameraSelectedNotifier, CameraEntity?>(
  CameraSelectedNotifier.new,
);

class CameraSelectedNotifier extends Notifier<CameraEntity?> {
  @override
  CameraEntity? build() => null;

  void select(CameraEntity camera) => state = camera;

  Future<void> move(double x, double y) async {
    if (state == null) return;
    try {
      debugPrint('[PTZ Mobile] Moviendo cámara: serial=${state!.serial}, x=$x, y=$y, onvif=${state!.onvifApiUrl}');
      final repo = ref.read(cameraRepositoryProvider);
      await repo.moveCamera(state!.serial, x, y, onvifApiUrl: state!.onvifApiUrl);
      debugPrint('[PTZ Mobile] Movimiento exitoso: serial=${state!.serial}');
    } catch (e) {
      debugPrint('[PTZ Mobile] Error moviendo cámara: $e');
    }
  }
}
