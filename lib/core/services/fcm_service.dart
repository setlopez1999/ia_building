import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/storage/tools/local_storage.dart';

import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.init();
  final payload = _extractPayload(message);
  await NotificationService.show(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: message.notification?.title ?? 'Alerta',
    body: message.notification?.body ?? 'Movimiento detectado',
    payload: payload,
  );
}

Map<String, dynamic>? _extractPayload(RemoteMessage message) {
  final data = message.data;
  if (data.isEmpty) return null;
  final video = data['video'] as String? ?? '';
  final serial = data['serial'] as String? ?? '';
  final ip = data['ip'] as String? ?? '';
  if (video.isEmpty && serial.isEmpty) return null;
  return {'video': video, 'serial': serial, 'ip': ip};
}

class FcmService {
  static String? _token;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Request permission (iOS)
      await messaging.requestPermission(
        
      );

      // Get FCM token
      _token = await messaging.getToken();
      debugPrint('[FCM] Token: $_token');

      // Save token locally
      if (_token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _token!);
      }

      // Send token to server
      if (_token != null) {
        await _sendTokenToServer(_token!);
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleMessage);

      // Handle notification tap from background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedApp);

      // Handle notification that opened app from terminated state
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleOpenedApp(initialMessage);
      }

      // Refresh token when it changes
      messaging.onTokenRefresh.listen((newToken) {
        _token = newToken;
        _sendTokenToServer(newToken);
        debugPrint('[FCM] Token refreshed: $newToken');
      });

      _initialized = true;
      debugPrint('[FCM] Initialized successfully');
    } catch (e) {
      debugPrint('[FCM] Init error: $e');
    }
  }

  static void _handleMessage(RemoteMessage message) {
    debugPrint('[FCM] Message: ${message.notification?.title}');
    final title = message.notification?.title ?? 'Alerta';
    final body = message.notification?.body ?? 'Movimiento detectado';
    NotificationService.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: _extractPayload(message),
    );
  }

  static void _handleOpenedApp(RemoteMessage message) {
    debugPrint('[FCM] Opened app from notification: ${message.notification?.title}');
    final payload = _extractPayload(message);
    if (payload != null) {
      NotificationService.onTapCallback?.call(payload);
    }
  }

  static Future<void> registerWithCliente(String clienteId) async {
    if (clienteId.isEmpty) return;
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('fcm_token');
    }
    if (_token != null) {
      await _sendTokenToServer(_token!, clienteId: clienteId);
    }
  }

  static Future<void> _sendTokenToServer(String token, {String? clienteId}) async {
    try {
      final client = HttpClient();
      try {
        final request = await client.postUrl(
          Uri.parse('${Environment.webhookHost}/webhook/fcm-token'),
        );
        request.headers.set('Content-Type', 'application/json');
        request.write(jsonEncode({
          'token': token,
          'platform': 'android',
          'cliente_id': clienteId ?? LocalStorage.getClienteId() ?? '',
        }));
        final response = await request.close();
        debugPrint('[FCM] Token sent to server: ${response.statusCode}');
      } finally {
        client.close();
      }
    } catch (e) {
      debugPrint('[FCM] Error sending token: $e');
    }
  }
}
