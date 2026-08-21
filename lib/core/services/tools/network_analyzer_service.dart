import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class PingResult {
  final double avgPing;
  final double lossPercent;
  final double jitter;
  final bool success;

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

class SpeedTestResult {
  final double downloadMbps;
  final double uploadMbps;

  const SpeedTestResult({
    required this.downloadMbps,
    required this.uploadMbps,
  });
}

class NetworkAnalyzerService {
  final Dio _dio = Dio(
    BaseOptions(
      validateStatus: (_) => true,
    ),
  );

  Future<PingResult> analyze(String host, {int count = 4}) async {
    return ping(host, count: count);
  }

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

  /// Latencia real vía HTTP HEAD — a diferencia de `ping`, funciona igual en
  /// Android e iOS (Process.run no está disponible en iOS).
  ///
  /// Usa mediana (no promedio) para que un solo pico aislado no distorsione
  /// el resultado, y separa los intentos ~150ms para que no sean una sola ráfaga.
  Future<PingResult> checkHttpLatency(String url, {int attempts = 5}) async {
    final rtts = <double>[];

    for (var i = 0; i < attempts; i++) {
      final ms = await _measureHttpHead(url);
      if (ms != null) rtts.add(ms);
      if (i < attempts - 1) {
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    if (rtts.isEmpty) return PingResult.failure();

    final medianPing = _median(rtts);
    final lossPercent = ((attempts - rtts.length) / attempts) * 100;

    double jitter = 0;
    if (rtts.length > 1) {
      final mean = rtts.reduce((a, b) => a + b) / rtts.length;
      final variance =
          rtts.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
              rtts.length;
      jitter = sqrt(variance);
    }

    return PingResult(
      avgPing: medianPing,
      lossPercent: lossPercent,
      jitter: jitter,
      success: true,
    );
  }

  double _median(List<double> values) {
    final sorted = [...values]..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[mid];
    return (sorted[mid - 1] + sorted[mid]) / 2;
  }

  Future<double?> _measureHttpHead(String url) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _dio.head(
        url,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      stopwatch.stop();
      return stopwatch.elapsedMilliseconds.toDouble();
    } catch (_) {
      stopwatch.stop();
      return null;
    }
  }

  Future<SpeedTestResult> runSpeedTest({String? serverBaseUrl}) async {
    double downloadMbps = 0;
    try {
      // 3 parallel streaming connections, 5 seconds fixed
      downloadMbps = await _measureDownloadParallel();
      if (downloadMbps == 0) {
        // Fallback: OVH single stream
        downloadMbps = await _measureDownloadOvhStream();
      }
    } catch (e) {
      debugPrint('[Speedtest] Download error: $e');
    }

    double uploadMbps = 0;
    try {
      uploadMbps = await _measureUpload();
    } catch (e) {
      debugPrint('[Speedtest] Upload error: $e');
    }

    debugPrint('[Speedtest] ↓${downloadMbps.toStringAsFixed(1)} ↑${uploadMbps.toStringAsFixed(1)} Mbps');
    return SpeedTestResult(downloadMbps: downloadMbps, uploadMbps: uploadMbps);
  }

  /// 3 conexiones paralelas en stream, corte exacto a los 5 segundos.
  /// Suma los bytes de todas las conexiones → mucho más preciso en redes rápidas.
  Future<double> _measureDownloadParallel() async {
    const testDuration = Duration(seconds: 5);
    const parallelConnections = 3;
    // 100 MB nominal — nunca termina en 5s; el timer corta la conexión
    const url = 'https://speed.cloudflare.com/__down?bytes=100000000';

    final sw = Stopwatch()..start();
    final bytesList = await Future.wait(
      List.generate(parallelConnections, (_) => _streamDownload(url, testDuration)),
    );
    sw.stop();

    final totalBytes = bytesList.fold(0, (sum, b) => sum + b);
    if (totalBytes == 0) return 0;

    final sec = sw.elapsedMilliseconds / 1000.0;
    final mbps = (totalBytes * 8) / (sec * 1000000);
    debugPrint('[Speedtest] CF parallel: ${mbps.toStringAsFixed(2)} Mbps '
        '(${(totalBytes / 1024 / 1024).toStringAsFixed(1)} MB / ${sec.toStringAsFixed(1)}s)');
    return mbps;
  }

  /// Stream individual con CancelToken — acumula bytes hasta que el timer corta.
  Future<int> _streamDownload(String url, Duration duration) async {
    final cancelToken = CancelToken();
    int bytes = 0;

    final timer = Timer(duration, () {
      if (!cancelToken.isCancelled) cancelToken.cancel('timeout');
    });

    try {
      final response = await _dio.get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: duration + const Duration(seconds: 3),
        ),
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200 || response.data == null) return 0;

      await for (final chunk in response.data!.stream) {
        bytes += chunk.length;
      }
    } on DioException catch (e) {
      if (!CancelToken.isCancel(e)) {
        debugPrint('[Speedtest] Stream DioException: ${e.message}');
      }
      // Cancel por timer es esperado — bytes acumulados son válidos
    } catch (e) {
      debugPrint('[Speedtest] Stream error: $e');
    } finally {
      timer.cancel();
    }

    return bytes;
  }

  /// Fallback OVH: stream único con corte a los 8 segundos.
  Future<double> _measureDownloadOvhStream() async {
    const testDuration = Duration(seconds: 8);
    const url = 'https://proof.ovh.net/files/10Mb.dat';

    final sw = Stopwatch()..start();
    final bytes = await _streamDownload(url, testDuration);
    sw.stop();

    if (bytes == 0) return 0;
    final sec = sw.elapsedMilliseconds / 1000.0;
    final mbps = (bytes * 8) / (sec * 1000000);
    debugPrint('[Speedtest] OVH fallback: ${mbps.toStringAsFixed(2)} Mbps');
    return mbps;
  }

  /// Upload: Uint8List de 2 MB (zeros — generación instantánea, sin Random overhead).
  Future<double> _measureUpload() async {
    const uploadBytes = 2 * 1024 * 1024;
    final data = Uint8List(uploadBytes); // zeros, instantáneo

    final sw = Stopwatch()..start();
    try {
      await http.post(
        Uri.parse('https://speed.cloudflare.com/__up'),
        body: data,
        headers: {'Content-Type': 'application/octet-stream'},
      ).timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('[Speedtest] Upload error: $e');
    }
    sw.stop();

    final sec = sw.elapsedMilliseconds / 1000.0;
    // Si tardó >= 20s es un timeout, no una medición válida
    if (sec <= 0 || sec >= 20) return 0;
    final mbps = (uploadBytes * 8) / (sec * 1000000);
    debugPrint('[Speedtest] Upload: ${mbps.toStringAsFixed(2)} Mbps en ${sec.toStringAsFixed(1)}s');
    return mbps;
  }
}

final networkAnalyzerServiceProvider = Provider<NetworkAnalyzerService>(
  (_) => NetworkAnalyzerService(),
);
