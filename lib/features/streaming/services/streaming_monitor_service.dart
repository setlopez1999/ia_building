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
    'netflix': 'custom.netflix.com',
    'youtube': 'google.com',
    'disney': 'cloudfront.net',
    'hbomax': 'azure.microsoft.com',
    'prime': 'atv-ps.amazon.com',
  };

  @override
  void build(String platformId) {
    _startPeriodicMonitoring(platformId);
    ref.onDispose(() => _timer?.cancel());
  }

  void _startPeriodicMonitoring(String platformId) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 8),
      (_) => _performAnalysis(platformId),
    );
  }

  Future<void> _performAnalysis(String platformId) async {
    final target = _platformTargets[platformId];
    if (target == null) return;

    final result = await _analyzer.analyze(target, count: 2);

    double baseSpeed = 40.0 + _random.nextDouble() * 20.0;
    if (result.success) {
      if (result.avgPing < 50) baseSpeed += 20;
      if (result.avgPing > 150) baseSpeed -= 15;

      final repository = ref.read(streamingRepositoryProvider);
      repository.updatePlatformMetrics(
        id: platformId,
        speed: baseSpeed,
        upload: baseSpeed / 4,
      );
    }
  }
}
