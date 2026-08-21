import 'package:flutter/foundation.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/domain/entities/tools/camera_event_entity.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/cameras_api_client.dart';
import 'package:tvapp/ui/shared/utils/srt.dart';
import 'camera_repository.dart';

class CameraRepositoryImpl implements CameraRepository {
  @override
  Future<List<CameraEntity>> getCameras({required String clienteId}) async {
    final data = await CamerasApiClient.getCameras(clienteId);
    final list = data['camaras'] as List<dynamic>;
    final cameras = list.map((e) {
      final srt = e['srt_url'] as String? ?? '';
      final onvifUrl = e['onvif_api_url'] as String? ?? '';
      final motionLog = e['motion_log_url'] as String? ?? '';
      final srtPuertoRaw = e['srt_puerto'];
      final srtPuerto = srtPuertoRaw?.toString();
      debugPrint('[CameraRepo] Cámara: serial=${e['serial_camara']}, srt=$srt, onvif=$onvifUrl');
      return CameraEntity(
        id: e['serial_camara'] as String,
        serial: e['serial_camara'] as String? ?? '',
        name: e['nombre_camara'] as String? ?? '',
        srt: srt.isNotEmpty ? buildSrtUrl(srt) : '',
        hls: e['hls_url'] as String? ?? '',
        onvif: onvifUrl,
        motionLogUrl: motionLog,
        onvifApiUrl: onvifUrl,
        ipCamara: e['ip_camara'] as String? ?? '',
        usuario: e['usuario'] as String? ?? '',
        passwordCamara: e['password_camara'] as String? ?? '',
        srtPuerto: srtPuerto,
      );
    }).toList();
    return cameras;
  }

  @override
  Future<List<CameraEventEntity>> getCameraEvents(String motionLogUrl) async {
    final data = await CamerasApiClient.getEventLog(motionLogUrl);
    final list = data['eventos'] as List<dynamic>;
    return list.map((e) => CameraEventEntity(
      tipo: e['tipo'] as String? ?? '',
      unix: e['unix'] as int? ?? 0,
      utc: e['utc'] as String? ?? '',
      video: e['video'] as String? ?? '',
      duracion: e['duracion'] as int? ?? 0,
      ip: e['ip'] as String? ?? '',
      serial: e['serial'] as String? ?? '',
    )).toList();
  }

  @override
  Future<void> moveCamera(String id, double x, double y, {String? onvifApiUrl}) async {
    debugPrint('[CameraRepo] Enviando PTZ: id=$id, x=$x, y=$y, onvifApiUrl=$onvifApiUrl');
    if (onvifApiUrl != null && onvifApiUrl.isNotEmpty) {
      await CamerasApiClient.movePtz(onvifApiUrl, x, y);
    } else {
      debugPrint('[CameraRepo] No hay onvifApiUrl para PTZ en cámara $id');
    }
  }

  @override
  Future<void> syncEvents() async {
    debugPrint('[CameraRepo] syncEvents no aplica para nuevo API');
  }
}
