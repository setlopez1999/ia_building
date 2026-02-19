import 'dart:io';
import 'dart:async';
import 'dart:math';

class PingResult {
  final double avgPing;
  final double lossPercent;
  final double jitter;
  final bool success;

  PingResult({
    required this.avgPing,
    required this.lossPercent,
    required this.jitter,
    required this.success,
  });

  factory PingResult.failure() =>
      PingResult(avgPing: 0, lossPercent: 100, jitter: 0, success: false);
}

class NetworkAnalyzerService {
  /// Realiza un análisis de red para un host específico.
  /// Ejecuta el comando ping del sistema operativo.
  Future<PingResult> analyze(String host, {int count = 4}) async {
    try {
      // Usamos el comando ping del sistema.
      // En Windows es 'ping -n count host'
      // En Unix es 'ping -c count host'
      final isWindows = Platform.isWindows;
      final args = isWindows
          ? ['-n', count.toString(), host]
          : ['-c', count.toString(), host];

      final result = await Process.run('ping', args);

      if (result.exitCode != 0) {
        return PingResult.failure();
      }

      final output = result.stdout.toString();
      return _parsePingOutput(output, isWindows);
    } catch (e) {
      return PingResult.failure();
    }
  }

  PingResult _parsePingOutput(String output, bool isWindows) {
    try {
      final List<double> rtts = [];
      int received = 0;
      int sent = 0;

      if (isWindows) {
        // Ejemplo Windows: Tiempo=28ms o time=28ms
        final timeRegex = RegExp(
          r'(?:tiempo|time)[=<](\d+)ms',
          caseSensitive: false,
        );
        final matches = timeRegex.allMatches(output);
        for (final match in matches) {
          final ms = double.tryParse(match.group(1) ?? '');
          if (ms != null) {
            rtts.add(ms);
            received++;
          }
        }

        final sentRegex = RegExp(r'Enviados = (\d+)', caseSensitive: false);
        final sentMatch = sentRegex.firstMatch(output);
        sent = int.tryParse(sentMatch?.group(1) ?? '4') ?? 4;
      } else {
        // Ejemplo Unix: 64 bytes from ...: icmp_seq=1 ttl=54 time=28.1 ms
        final timeRegex = RegExp(r'time=(\d+\.?\d*)', caseSensitive: false);
        final matches = timeRegex.allMatches(output);
        for (final match in matches) {
          final ms = double.tryParse(match.group(1) ?? '');
          if (ms != null) {
            rtts.add(ms);
            received++;
          }
        }
        sent = 4; // Simplificado para Unix por ahora
      }

      if (rtts.isEmpty) return PingResult.failure();

      final avgPing = rtts.reduce((a, b) => a + b) / rtts.length;
      final lossPercent = ((sent - received) / sent) * 100;

      // Cálculo de Jitter (Desviación estándar de los RTTs)
      double jitter = 0;
      if (rtts.length > 1) {
        final variance =
            rtts.map((x) => pow(x - avgPing, 2)).reduce((a, b) => a + b) /
            rtts.length;
        jitter = sqrt(variance);
      }

      return PingResult(
        avgPing: avgPing,
        lossPercent: lossPercent,
        jitter: jitter,
        success: true,
      );
    } catch (e) {
      return PingResult.failure();
    }
  }
}
