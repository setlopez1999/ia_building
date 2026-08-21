String buildSrtUrl(String baseUrl) {
  final uri = Uri.parse(baseUrl);
  final params = Map<String, String>.from(uri.queryParameters)
    ..putIfAbsent('latency', () => '120')
    ..putIfAbsent('rcvbuf', () => '1048576');
  return uri.replace(queryParameters: params).toString();
}
