import '../../domain/entities/network_metrics.dart';

class PingResultDto {
  final double avgPing;
  final double lossPercent;
  final double jitter;
  final bool success;

  PingResultDto({
    required this.avgPing,
    required this.lossPercent,
    required this.jitter,
    required this.success,
  });

  factory PingResultDto.failure() =>
      PingResultDto(avgPing: 0, lossPercent: 100, jitter: 0, success: false);

  NetworkMetrics toEntity() => NetworkMetrics(
        avgPing: avgPing,
        lossPercent: lossPercent,
        jitter: jitter,
        success: success,
      );
}
