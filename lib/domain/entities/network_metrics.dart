class NetworkMetrics {
  final double avgPing;
  final double lossPercent;
  final double jitter;
  final bool success;

  const NetworkMetrics({
    required this.avgPing,
    required this.lossPercent,
    required this.jitter,
    required this.success,
  });

  factory NetworkMetrics.failure() => const NetworkMetrics(
        avgPing: 0,
        lossPercent: 100,
        jitter: 0,
        success: false,
      );

  String get pingStatus => fromPing(avgPing);

  static String fromPing(double pingMs) {
    if (pingMs == 0) return "Sin Conexión";
    if (pingMs < 35) return "Excelente";
    if (pingMs < 60) return "Muy Bueno";
    if (pingMs < 100) return "Bueno";
    if (pingMs < 150) return "Regular";
    return "Malo";
  }
}
