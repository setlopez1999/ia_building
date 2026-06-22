import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Resultados ────────────────────────────────────────────────────────────────

/// Resultado de un ping nativo al dispositivo.
class PingResult {
  final double avgPing;
  final double lossPercent;
  final double jitter;
  final bool success;

  /// Alias para compatibilidad con DiagnosticoNotifier.
  double get avgMs => avgPing;

  PingResult({
    required this.avgPing,
    required this.lossPercent,
    required this.jitter,
    required this.success,
  });

  factory PingResult.failure() =>
      PingResult(avgPing: 0, lossPercent: 100, jitter: 0, success: false);
}

/// Resultado del speedtest local.
class SpeedTestResult {
  final double downloadMbps;
  final double uploadMbps;

  const SpeedTestResult({
    required this.downloadMbps,
    required this.uploadMbps,
  });
}

// ── Servicio ──────────────────────────────────────────────────────────────────

/// Servicio de análisis de red: ping nativo y speedtest local.
/// Las IPs de ping se leen de SharedPreferences (nunca hardcodeadas).
/// No hace llamadas al backend; es 100% local (CU en el plan).
class NetworkAnalyzerService {
  /// Realiza un análisis de red para un host específico.
  /// Ejecuta el comando ping del sistema operativo.
  Future<PingResult> analyze(String host, {int count = 4}) async {
    return ping(host, count: count);
  }

  /// Ejecuta ping nativo al [host] con [count] paquetes.
  Future<PingResult> ping(String host, {int count = 4}) async {
    try {
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
        final timeRegex = RegExp(r'time=(\d+\.?\d*)', caseSensitive: false);
        final matches = timeRegex.allMatches(output);
        for (final match in matches) {
          final ms = double.tryParse(match.group(1) ?? '');
          if (ms != null) {
            rtts.add(ms);
            received++;
          }
        }
        final sentMatch =
            RegExp(r'(\d+) packets transmitted').firstMatch(output);
        sent = int.tryParse(sentMatch?.group(1) ?? '4') ?? 4;
      }

      if (rtts.isEmpty) return PingResult.failure();

      final avgPing = rtts.reduce((a, b) => a + b) / rtts.length;
      final lossPercent = ((sent - received) / sent) * 100;

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

  /// Ejecuta un speedtest simplificado.
  /// TODO: integrar librería de speedtest real (speed_test_dart o similar).
  /// Por ahora devuelve valores simulados para que la UI funcione.
  Future<SpeedTestResult> runSpeedTest() async {
    await Future.delayed(const Duration(seconds: 3));
    return const SpeedTestResult(downloadMbps: 0, uploadMbps: 0);
  }
}

/// Provider global del NetworkAnalyzerService.
final networkAnalyzerServiceProvider = Provider<NetworkAnalyzerService>(
  (_) => NetworkAnalyzerService(),
);
