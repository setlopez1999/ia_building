import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/network_analyzer_service.dart';
import '../providers/streaming_provider.dart';

part 'streaming_monitor_service.g.dart';

@riverpod
class StreamingMonitor extends _$StreamingMonitor {
  Timer? _timer;
  final _analyzer = NetworkAnalyzerService();
  final _random = Random();

  final Map<String, String> _platformTargets = {
    'netflix': 'custom.netflix.com', // AWS/Netflix
    'youtube': 'google.com',
    'disney': 'cloudfront.net',
    'hbomax': 'azure.microsoft.com',
    'prime': 'atv-ps.amazon.com',
  };

  @override
  void build() {
    _startMonitoring();
    ref.onDispose(() => _timer?.cancel());
  }

  void _startMonitoring() {
    _timer?.cancel();
    _performAnalysis();
    _timer = Timer.periodic(
      const Duration(seconds: 8),
      (_) => _performAnalysis(),
    );
  }

  Future<void> _performAnalysis() async {
    final repository = ref.read(streamingRepositoryProvider);

    final futures = _platformTargets.entries.map((entry) async {
      final id = entry.key;
      final target = entry.value;

      final result = await _analyzer.analyze(target, count: 2);

      // Simulamos una velocidad basada en el ping para que parezca real
      // A menor ping, mayor velocidad (dentro de un rango)
      double baseSpeed = 40.0 + _random.nextDouble() * 20.0;
      if (result.success) {
        if (result.avgPing < 50) baseSpeed += 20;
        if (result.avgPing > 150) baseSpeed -= 15;

        repository.updatePlatformMetrics(
          id: id,
          speed: baseSpeed,
          upload: baseSpeed / 4,
        );
      } else {
        repository.updatePlatformMetrics(id: id, speed: 0, upload: 0);
      }
    });

    await Future.wait(futures);
  }
}
