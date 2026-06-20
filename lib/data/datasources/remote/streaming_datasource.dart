class StreamingDataSource {
  final Map<String, String> platformTargets = {
    'netflix': 'custom.netflix.com',
    'youtube': 'google.com',
    'disney': 'cloudfront.net',
    'hbomax': 'azure.microsoft.com',
    'prime': 'atv-ps.amazon.com',
  };

  String? getTarget(String platformId) => platformTargets[platformId];
}
