class GameServerMetrics {
  final String id;
  final String gameName;
  final String ping;
  final String loss;
  final String jitter;
  final String status;
  final String serverName;
  final String serverLocation;
  final String logoAsset;

  const GameServerMetrics({
    required this.id,
    required this.gameName,
    required this.ping,
    required this.loss,
    required this.jitter,
    required this.status,
    required this.serverName,
    required this.serverLocation,
    this.logoAsset = '',
  });

  GameServerMetrics copyWith({
    String? ping,
    String? loss,
    String? jitter,
    String? status,
    String? serverName,
    String? serverLocation,
    String? logoAsset,
  }) {
    return GameServerMetrics(
      id: id,
      gameName: gameName,
      ping: ping ?? this.ping,
      loss: loss ?? this.loss,
      jitter: jitter ?? this.jitter,
      status: status ?? this.status,
      serverName: serverName ?? this.serverName,
      serverLocation: serverLocation ?? this.serverLocation,
      logoAsset: logoAsset ?? this.logoAsset,
    );
  }
}
