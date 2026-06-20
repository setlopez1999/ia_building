import '../entities/network_metrics.dart';
import '../repositories/i_network_repository.dart';

class CheckNetworkHealth {
  final INetworkRepository repository;

  CheckNetworkHealth(this.repository);

  Future<NetworkMetrics> call(String host, {int count = 4}) {
    return repository.analyze(host, count: count);
  }
}
