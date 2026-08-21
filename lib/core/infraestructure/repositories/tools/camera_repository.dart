import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/domain/entities/tools/camera_event_entity.dart';

abstract class CameraRepository {
  Future<List<CameraEntity>> getCameras({required String clienteId});
  Future<List<CameraEventEntity>> getCameraEvents(String motionLogUrl);
  Future<void> moveCamera(String id, double x, double y, {String? onvifApiUrl});
  Future<void> syncEvents();
}
