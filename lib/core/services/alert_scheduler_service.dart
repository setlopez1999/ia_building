import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/storage/tools/local_storage.dart';

class AlertConfig {
  final bool enabled;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final List<int> days;
  final int preAlertMinutes;
  final String serial;

  const AlertConfig({
    required this.enabled,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.days,
    this.preAlertMinutes = 5,
    required this.serial,
  });

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'startHour': startHour,
    'startMinute': startMinute,
    'endHour': endHour,
    'endMinute': endMinute,
    'days': days,
    'preAlertMinutes': preAlertMinutes,
    'serial': serial,
  };

  factory AlertConfig.fromJson(Map<String, dynamic> json) => AlertConfig(
    enabled: json['enabled'] as bool? ?? false,
    startHour: json['startHour'] as int? ?? 0,
    startMinute: json['startMinute'] as int? ?? 0,
    endHour: json['endHour'] as int? ?? 0,
    endMinute: json['endMinute'] as int? ?? 0,
    days: (json['days'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    preAlertMinutes: json['preAlertMinutes'] as int? ?? 5,
    serial: json['serial'] as String? ?? '',
  );

  bool isActiveForNow() {
    if (!enabled) return false;
    final now = DateTime.now();
    final weekday = now.weekday - 1;
    if (!days.contains(weekday)) return false;
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;
    return currentMinutes >= startMinutes && currentMinutes < endMinutes;
  }
}

class AlertSchedulerService {
  static const storageKey = 'camera_alerts';
  static Timer? _timer;
  static final Set<String> _notifiedSerials = {};

  static Future<void> saveConfig(AlertConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAllConfigs();
    all[config.serial] = config;
    await prefs.setString(storageKey, jsonEncode(all.map((k, v) => MapEntry(k, v.toJson()))));
    _notifiedSerials.remove(config.serial);
    _scheduleCheck();
    unawaited(syncConfigToServer(config));
  }

  static Future<void> syncConfigToServer(AlertConfig config) async {
    try {
      final client = HttpClient();
      try {
        final request = await client.postUrl(
          Uri.parse('${Environment.webhookHost}/api/alert-config'),
        );
        request.headers.set('Content-Type', 'application/json');
        request.write(jsonEncode({
          'serial_camara': config.serial,
          'cliente_id': LocalStorage.getClienteId() ?? '',
          'enabled': config.enabled,
          'startHour': config.startHour,
          'startMinute': config.startMinute,
          'endHour': config.endHour,
          'endMinute': config.endMinute,
          'days': config.days,
          'preAlertMinutes': config.preAlertMinutes,
        }));
        final response = await request.close();
        debugPrint('[AlertScheduler] Config subida al servidor: ${response.statusCode}');
      } finally {
        client.close();
      }
    } catch (e) {
      debugPrint('[AlertScheduler] Error subiendo config: $e');
    }
  }

  static Future<Map<String, AlertConfig>> loadAllConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, AlertConfig.fromJson(v as Map<String, dynamic>)));
  }

  static Future<AlertConfig?> loadConfig(String serial) async {
    final all = await loadAllConfigs();
    return all[serial];
  }

  static Future<void> removeConfig(String serial) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAllConfigs();
    all.remove(serial);
    await prefs.setString(storageKey, jsonEncode(all.map((k, v) => MapEntry(k, v.toJson()))));
    _notifiedSerials.remove(serial);
  }

  static void _scheduleCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _checkAlerts());
  }

  static Future<void> _checkAlerts() async {
    final all = await loadAllConfigs();
    for (final entry in all.entries) {
      final config = entry.value;
      if (!config.isActiveForNow()) {
        _notifiedSerials.remove(config.serial);
        continue;
      }
      if (_notifiedSerials.contains(config.serial)) continue;

      final events = await _fetchEvents(config);
      if (events.isEmpty) continue;

      _notifiedSerials.add(config.serial);
      final serialShort = config.serial.length > 10
          ? '${config.serial.substring(0, 10)}...'
          : config.serial;

      String videoUrl = '';
      for (final ev in events) {
        final v = ev['video'] as String? ?? '';
        if (v.isNotEmpty) {
          videoUrl = v;
          break;
        }
      }

      await NotificationService.show(
        id: config.serial.hashCode,
        title: 'Movimiento detectado',
        body: '${events.length} evento(s) en cámara $serialShort '
            '(${config.startHour.toString().padLeft(2, '0')}:${config.startMinute.toString().padLeft(2, '0')} - '
            '${config.endHour.toString().padLeft(2, '0')}:${config.endMinute.toString().padLeft(2, '0')})',
        payload: videoUrl.isNotEmpty
            ? {'video': videoUrl, 'serial': config.serial}
            : null,
      );
    }
  }

  static Future<List<Map<String, dynamic>>> _fetchEvents(AlertConfig config) async {
    try {
      final now = DateTime.now();
      final startTime = DateTime(
        now.year, now.month, now.day,
        config.startHour, config.startMinute,
      ).subtract(Duration(minutes: config.preAlertMinutes));
      final endTime = DateTime(
        now.year, now.month, now.day,
        config.endHour, config.endMinute,
      );
      final since = startTime.millisecondsSinceEpoch ~/ 1000;
      final until = endTime.millisecondsSinceEpoch ~/ 1000;
      final url = '${Environment.webhookHost}/logs/movimiento/'
          '${config.serial}?since=$since&until=$until&lines=50';

      final client = HttpClient();
      try {
        final request = await client.getUrl(Uri.parse(url));
        request.headers.set('Accept', 'application/json');
        final response = await request.close();
        final body = await response.transform(utf8.decoder).join();
        if (response.statusCode != 200) return [];
        final data = jsonDecode(body) as Map<String, dynamic>;
        return (data['eventos'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      } finally {
        client.close();
      }
    } catch (e) {
      debugPrint('[AlertScheduler] Error: $e');
      return [];
    }
  }

  static void start() {
    _scheduleCheck();
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
