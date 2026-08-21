import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static void Function(Map<String, dynamic> payload)? onTapCallback;

  static Future<void> init({void Function(Map<String, dynamic> payload)? onTap}) async {
    if (_initialized) return;
    try {
      onTapCallback = onTap;
      const androidSettings = AndroidInitializationSettings('@drawable/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      await _plugin.initialize(
        const InitializationSettings(android: androidSettings, iOS: iosSettings),
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );
      await _requestPermission();
      _initialized = true;
    } catch (e) {
      debugPrint('[NotificationService] Init error: $e');
    }
  }

  static Future<void> _requestPermission() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('[NotificationService] Permission request error: $e');
    }
  }

  static void _handleNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      onTapCallback?.call(data);
    } catch (e) {
      debugPrint('[NotificationService] Tap payload parse error: $e');
    }
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    if (!_initialized) return;
    try {
      await _plugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'camera_alerts',
            'Alertas de Cámara',
            channelDescription: 'Notificaciones de movimiento detectado',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: payload != null ? jsonEncode(payload) : null,
      );
    } catch (e) {
      debugPrint('[NotificationService] Show error: $e');
    }
  }
}
