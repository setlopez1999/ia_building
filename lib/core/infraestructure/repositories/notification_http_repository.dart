import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/core/domain/entities/notifyme/notifyme_entity.dart';
import 'package:tvapp/core/domain/repositories/notification_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class NotificationHttpRepository implements NotificationRepository {
  final dio = Dio();

  @override
  Future<Either<AppException, List<NotificationEntity>>> getNotifications(
      String userId) async {
    final url = '${Environment.baseHost}/api/notifications';
    final response = await dio.get(url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          validateStatus: (status) => true,
        ),
        data: jsonEncode(
          {
            'user_id': userId,
          },
        ));

    if (response.statusCode != 200) {
      print("Error fetching notifications: ${response.statusCode}");
      return Left(AppException(
          identifier: 'getNotifications', message: 'Error', statusCode: 5000));
    }


    final dto = (response.data as List<dynamic>).map((e) => NotificationEntity.fromJson(e)).toList();
    return Right(dto.toList());
  }

  @override
  Future<void> markAsRead(NotificationEntity notification, String userID) async {
    final url = '${Environment.baseHost}/api/notifications';
    await dio.post(url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          validateStatus: (status) => true,
        ),
        data: jsonEncode(
          {
            'user_id': userID,
            'notification_id': notification.id,
          },
        ));
  }

  @override
  Future<void> saveLastDateRead(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastDateRead', date);
  }

  @override
  Future<String> getLastDateRead() async  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastDateRead') ?? '';
  }

  @override
  Future<void> createNotification(NotifymeEntity notify) async {

    final exists = await findNotifyme(notify.key);

    if(exists) {
      return;
    }

    final url = '${Environment.baseHost}/api/notifications/send';

    final response = await dio.post(url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          validateStatus: (status) => true,
        ),
        data: jsonEncode({
          'cn_id': notify.cn_id,
          'text': notify.text,
          'user_id': notify.user_id,
          'scheduled_date': notify.scheduled_date,
        })
    );

    if(response.statusCode != 200) {
      return;
    }

    await saveNotifyme(notify);
  }

  @override
  Future<Either<AppException, List<NotifymeEntity>>> listNotifyme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final strNotifications = prefs.getString('notitications_me') ?? '[]';
    final notifications = (jsonDecode(strNotifications) as List)
        .map((e) => NotifymeEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    return Right(notifications);
  }

  Future<bool> findNotifyme(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final strNotifications = prefs.getString('notitications_me') ?? '[]';
    final notifications = (jsonDecode(strNotifications) as List)
        .map((e) => NotifymeEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    return notifications.any((element) => element.key == key);
  }

  Future<void> saveNotifyme(NotifymeEntity notify) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final strNotifications = prefs.getString('notitications_me') ?? '[]';

    final notifications = (jsonDecode(strNotifications) as List)
        .map((e) => NotifymeEntity.fromJson(e as Map<String, dynamic>))
        .toList();

    // Eliminar notificaciones cuya fecha programada es anterior a hoy
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final notificationsFiltered = notifications.where((n) {
      final scheduledDate = DateTime.parse(n.scheduled_date);
      return !scheduledDate.isBefore(today); // mantener solo las futuras o de hoy
    }).toList()
    ..add(notify); // Agregar la nueva notificación

    // Guardar lista actualizada en SharedPreferences
    final updatedStr = jsonEncode(notificationsFiltered.map((n) => n.toJson()).toList());
    await prefs.setString('notitications_me', updatedStr);
  }

}
