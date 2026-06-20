class StreamingPlatformMetrics {
  final String id;
  final String name;
  final String logoAsset;
  final String downloadSpeed;
  final String uploadSpeed;
  final String serverName;
  final String serverLocation;

  const StreamingPlatformMetrics({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.serverName,
    required this.serverLocation,
  });

  StreamingPlatformMetrics copyWith({
    String? downloadSpeed,
    String? uploadSpeed,
    String? serverName,
    String? serverLocation,
  }) {
    return StreamingPlatformMetrics(
      id: id,
      name: name,
      logoAsset: logoAsset,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      serverName: serverName ?? this.serverName,
      serverLocation: serverLocation ?? this.serverLocation,
    );
  }
}
