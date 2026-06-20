import '../repositories/i_gaming_repository.dart';
import '../repositories/i_gaming_monitor_repository.dart';

class ProbeGamingServer {
  final IGamingRepository gamingRepository;
  final IGamingMonitorRepository monitorRepository;

  ProbeGamingServer({
    required this.gamingRepository,
    required this.monitorRepository,
  });

  Future<void> call(String gameId) async {
    final result = await monitorRepository.probeGame(gameId);
    if (result != null) {
      final ping = double.tryParse(result.ping.replaceAll(' ms', '')) ?? 0;
      final loss = double.tryParse(result.loss.replaceAll('%', '')) ?? 0;
      final jitterVal = double.tryParse(result.jitter.replaceAll('ms', '').trim()) ?? 0;

      gamingRepository.updateGameMetrics(
        id: gameId,
        ping: ping,
        loss: loss,
        jitter: jitterVal,
        serverName: result.serverName,
        serverLocation: result.serverLocation,
      );
    }
  }
}
