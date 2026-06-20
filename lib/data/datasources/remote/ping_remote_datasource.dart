import 'dart:io';
import 'dart:math';
import '../../models/ping_result_dto.dart';

class PingRemoteDataSource {
  static final RegExp _hostRegex = RegExp(
    r'^[a-zA-Z0-9]([a-zA-Z0-9\-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]*[a-zA-Z0-9])?)*'
    r'|'
    r'^(\d{1,3}\.){3}\d{1,3}$',
  );

  String? _sanitizeHost(String host) {
    final trimmed = host.trim();
    if (_hostRegex.hasMatch(trimmed)) return trimmed;
    return null;
  }

  Future<PingResultDto> analyze(String host, {int count = 4}) async {
    final safeHost = _sanitizeHost(host);
    if (safeHost == null) return PingResultDto.failure();

    try {
      final isWindows = Platform.isWindows;
      final args = isWindows
          ? ['-n', count.toString(), safeHost]
          : ['-c', count.toString(), safeHost];

      final result = await Process.run('ping', args);

      if (result.exitCode != 0) {
        return PingResultDto.failure();
      }

      final output = result.stdout.toString();
      return _parsePingOutput(output, isWindows);
    } catch (e) {
      return PingResultDto.failure();
    }
  }

  PingResultDto _parsePingOutput(String output, bool isWindows) {
    try {
      final List<double> rtts = [];
      int received = 0;
      int sent = 0;

      if (isWindows) {
        final timeRegex =
            RegExp(r'(?:tiempo|time)[=<](\d+)ms', caseSensitive: false);
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
        sent = 4;
      }

      if (rtts.isEmpty) return PingResultDto.failure();

      final avgPing = rtts.reduce((a, b) => a + b) / rtts.length;
      final lossPercent = ((sent - received) / sent) * 100;

      double jitter = 0;
      if (rtts.length > 1) {
        final variance =
            rtts.map((x) => pow(x - avgPing, 2)).reduce((a, b) => a + b) /
                rtts.length;
        jitter = sqrt(variance);
      }

      return PingResultDto(
        avgPing: avgPing,
        lossPercent: lossPercent,
        jitter: jitter,
        success: true,
      );
    } catch (e) {
      return PingResultDto.failure();
    }
  }
}
