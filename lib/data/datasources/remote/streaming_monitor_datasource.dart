import 'dart:math';
import 'ping_remote_datasource.dart';
import 'streaming_datasource.dart';

class StreamingMonitorDataSource {
  final PingRemoteDataSource _pingDataSource;
  final StreamingDataSource _streamingDataSource;
  final Random _random;

  StreamingMonitorDataSource({
    required PingRemoteDataSource pingDataSource,
    required StreamingDataSource streamingDataSource,
    Random? random,
  })  : _pingDataSource = pingDataSource,
        _streamingDataSource = streamingDataSource,
        _random = random ?? Random();

  Future<StreamingProbeResult> probePlatform(String platformId) async {
    final target = _streamingDataSource.getTarget(platformId);
    if (target == null) {
      return StreamingProbeResult(
        speed: 0,
        upload: 0,
        avgPing: 0,
        success: false,
      );
    }

    final result = await _pingDataSource.analyze(target, count: 2);

    // NOTA: La velocidad de descarga/subida es una estimacion basada
    // en el ping + un componente aleatorio. No es una velocidad real
    // medida por descarga de contenido. Para medicion real se necesita
    // un servidor de speedtest o descarga de un archivo conocido.
    double baseSpeed = 40.0 + _random.nextDouble() * 20.0;

    if (result.success) {
      if (result.avgPing < 50) baseSpeed += 20;
      if (result.avgPing > 150) baseSpeed -= 15;
    }

    return StreamingProbeResult(
      speed: baseSpeed,
      upload: baseSpeed / 4,
      avgPing: result.avgPing,
      success: result.success,
    );
  }
}

class StreamingProbeResult {
  final double speed;
  final double upload;
  final double avgPing;
  final bool success;

  StreamingProbeResult({
    required this.speed,
    required this.upload,
    required this.avgPing,
    required this.success,
  });
}
