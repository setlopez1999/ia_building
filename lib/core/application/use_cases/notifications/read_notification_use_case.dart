import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/core/domain/repositories/notification_repository.dart';

class ReadNotificationUseCase {

  ReadNotificationUseCase(this._notificationRepository);
  final NotificationRepository _notificationRepository;

  Future<void> execute(NotificationEntity notification, String userID) async {
    await _notificationRepository.markAsRead(notification, userID);
  }
}