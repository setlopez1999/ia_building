import '../entities/network_metrics.dart';

abstract class INetworkRepository {
  Future<NetworkMetrics> analyze(String host, {int count = 4});
}
