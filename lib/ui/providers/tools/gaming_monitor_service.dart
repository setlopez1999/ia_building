import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/services/tools/network_analyzer_service.dart';
import 'gaming_server_providers.dart';

part 'gaming_monitor_service.g.dart';

/// Monitor para la pantalla de detalle — sondeo profundo (count=3) de un servidor.
@riverpod
class GamingMonitor extends _$GamingMonitor {
  Timer? _timer;
  final _analyzer = NetworkAnalyzerService();

  @override
  void build(String servidorId) {
    _startPeriodicMonitoring(servidorId);
    ref.onDispose(() => _timer?.cancel());
  }

  void _startPeriodicMonitoring(String servidorId) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _performAnalysis(servidorId),
    );
  }

  Future<bool> probeOnce(String servidorId) async {
    return _performAnalysis(servidorId);
  }

  Future<bool> _performAnalysis(String servidorId) async {
    final repo = ref.read(gamingApiRepositoryImplProvider);
    final servidor = repo.getServidorById(servidorId);
    if (servidor == null || servidor.ip.isEmpty) return false;

    final result = await _analyzer.analyze(servidor.ip, count: 3);
    if (result.success) {
      repo.updateMetrics(
        id: servidorId,
        pingMs: result.avgPing.round(),
        jitterMs: result.jitter.round(),
        perdidaPaquetesPct: result.lossPercent,
      );
      return true;
    }
    return false;
  }
}

/// Monitor para la lista de juegos — arranca apenas se crea y se destruye al salir.
/// Usa count=1 (sondeo rápido) para todos los servidores en paralelo.
@riverpod
class GamingListMonitor extends _$GamingListMonitor {
  Timer? _timer;
  bool _disposed = false;
  final _analyzer = NetworkAnalyzerService();

  @override
  void build() {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });
    _loadAndStart();
  }

  Future<void> _loadAndStart() async {
    // Espera a que el FutureProvider cargue los servidores (path ya probado)
    try {
      await ref.read(servidoresJuegoProvider.future);
    } catch (_) {
      return;
    }
    if (_disposed) return;
    await _pingAll();
    if (_disposed) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _pingAll());
  }

  Future<void> _pingAll() async {
    final repo = ref.read(gamingApiRepositoryImplProvider);
    final servidores = repo.currentServidores;
    await Future.wait(
      servidores.where((s) => s.ip.isNotEmpty).map((sv) async {
        final result = await _analyzer.analyze(sv.ip, count: 1);
        if (result.success && !_disposed) {
          repo.updateMetrics(
            id: sv.id,
            pingMs: result.avgPing.round(),
            jitterMs: result.jitter.round(),
            perdidaPaquetesPct: result.lossPercent,
          );
        }
      }),
    );
  }
}
