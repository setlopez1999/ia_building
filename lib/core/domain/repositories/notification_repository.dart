import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/core/domain/entities/notifyme/notifyme_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class NotificationRepository {
  Future<Either<AppException, List<NotificationEntity>>> getNotifications(String userId);
  Future<void> markAsRead(NotificationEntity notification, String userId);
  Future<void> saveLastDateRead(String date);
  Future<String> getLastDateRead();
  Future<void> createNotification(NotifymeEntity notify);
  Future<Either<AppException, List<NotifymeEntity>>> listNotifyme();
}