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

  Future<SpeedTestResult> runSpeedTest({String? serverBaseUrl}) async {
    final baseUrl =
        (serverBaseUrl ?? 'https://serverpruebabryan.com.cd-latam.com')
            .replaceAll(RegExp(r'/+$'), '');

    double downloadMbps = 0;
    bool usedCloudflare = false;
    try {
      downloadMbps = await _measureDownloadSpeed(baseUrl);
      usedCloudflare = downloadMbps > 0;
      if (!usedCloudflare) {
        downloadMbps = await _measureDownloadBackend(baseUrl);
      }
    } catch (e) {
      debugPrint('[Speedtest] Download error: $e');
      try { downloadMbps = await _measureDownloadBackend(baseUrl); } catch (_) {}
    }

    double uploadMbps = 0;
    try {
      uploadMbps = await _measureUploadSpeed(baseUrl);
    } catch (e) {
      debugPrint('[Speedtest] Upload error: $e');
    }

    debugPrint('[Speedtest] Result: ${downloadMbps.toStringAsFixed(1)}/${uploadMbps.toStringAsFixed(1)} Mbps (${usedCloudflare ? "Cloudflare" : "Backend"})');
    return SpeedTestResult(
      downloadMbps: downloadMbps,
      uploadMbps: uploadMbps,
    );
  }

  Future<double> _measureDownloadSpeed(String _) async {
    const cfSizes = [25, 10, 5];
    for (final mb in cfSizes) {
      try {
        final uri = Uri.parse('https://speed.cloudflare.com/__down?bytes=${mb * 1_000_000}');
        final stopwatch = Stopwatch()..start();
        final resp = await http.get(uri).timeout(const Duration(seconds: 20));
        stopwatch.stop();
        final durationSec = stopwatch.elapsedMilliseconds / 1000.0;
        if (durationSec <= 0) continue;
        final bytes = resp.bodyBytes.length;
        final mbps = (bytes * 8) / (durationSec * 1_000_000);
        debugPrint('[Speedtest] CF ${mb}MB: ${mbps.toStringAsFixed(2)} Mbps');
        if (mbps > 0) return mbps;
      } catch (e) {
        debugPrint('[Speedtest] CF ${mb}MB failed: $e');
      }
    }
    return 0;
  }

  Future<double> _measureDownloadBackend(String baseUrl) async {
    const sizes = [5, 2, 1];
    for (final mb in sizes) {
      try {
        final uri = Uri.parse('$baseUrl/v1/speedtest/download?mb=$mb');
        final stopwatch = Stopwatch()..start();
        final resp = await http.get(uri).timeout(const Duration(seconds: 20));
        stopwatch.stop();
        final durationSec = stopwatch.elapsedMilliseconds / 1000.0;
        if (durationSec <= 0) continue;
        final bytes = resp.bodyBytes.length;
        final mbps = (bytes * 8) / (durationSec * 1_000_000);
        debugPrint('[Speedtest] Backend ${mb}MB: ${mbps.toStringAsFixed(2)} Mbps');
        if (mbps > 0) return mbps;
      } catch (e) {
        debugPrint('[Speedtest] Backend ${mb}MB failed: $e');
      }
    }
    return 0;
  }

  Future<double> _measureUploadSpeed(String baseUrl) async {
    // Try Cloudflare upload first
    const uploadSize = 10 * 1024 * 1024;
    final data = List<int>.generate(uploadSize, (_) => Random().nextInt(256));
    try {
      final uri = Uri.parse('https://speed.cloudflare.com/__up');
      final stopwatch = Stopwatch()..start();
      final resp = await http
          .post(uri, body: data, headers: {'Content-Type': 'application/octet-stream'})
          .timeout(const Duration(seconds: 20));
      stopwatch.stop();
      final durationSec = stopwatch.elapsedMilliseconds / 1000.0;
      if (durationSec > 0) {
        final mbps = (uploadSize * 8) / (durationSec * 1_000_000);
        debugPrint('[Speedtest] CF upload: ${mbps.toStringAsFixed(2)} Mbps');
        return mbps;
      }
    } catch (e) {
      debugPrint('[Speedtest] CF upload failed: $e');
    }

    // Fallback to backend upload
    try {
      const smallUpload = 512 * 1024;
      final smallData = List<int>.generate(smallUpload, (_) => Random().nextInt(256));
      final uri = Uri.parse('$baseUrl/v1/speedtest/upload');
      final stopwatch = Stopwatch()..start();
      await http
          .post(uri, body: smallData, headers: {'Content-Type': 'application/octet-stream'})
          .timeout(const Duration(seconds: 20));
      stopwatch.stop();
      final durationSec = stopwatch.elapsedMilliseconds / 1000.0;
      if (durationSec > 0) {
        final mbps = (smallUpload * 8) / (durationSec * 1_000_000);
        debugPrint('[Speedtest] Backend upload: ${mbps.toStringAsFixed(2)} Mbps');
        return mbps;
      }
    } catch (e) {
      debugPrint('[Speedtest] Backend upload failed: $e');
    }
    return 0;
  }
}

final networkAnalyzerServiceProvider = Provider<NetworkAnalyzerService>(
  (_) => NetworkAnalyzerService(),
);
