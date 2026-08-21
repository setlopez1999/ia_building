import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tvapp/config/environment/environment.dart';

class CamerasApiClient {
  static String get _baseUrl => Environment.webhookHost;

  static Future<Map<String, dynamic>> getCameras(String clienteId) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('$_baseUrl/api/camaras/$clienteId'));
      request.headers.set('Accept', 'application/json');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw Exception('Error ${response.statusCode}: $body');
      }
      final data = jsonDecode(body) as Map<String, dynamic>;
      return data;
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> getEventLog(String motionLogUrl) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(motionLogUrl));
      request.headers.set('Accept', 'application/json');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw Exception('Error ${response.statusCode}: $body');
      }
      final data = jsonDecode(body) as Map<String, dynamic>;
      return data;
    } finally {
      client.close();
    }
  }

  static Future<void> movePtz(String onvifApiUrl, double x, double y) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('$onvifApiUrl/move');
      final request = await client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      request.write(jsonEncode({'x': x, 'y': y}));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('[CamerasApiClient] PTZ error ${response.statusCode}: $body');
        throw Exception('Error PTZ ${response.statusCode}');
      }
    } finally {
      client.close();
    }
  }
}
