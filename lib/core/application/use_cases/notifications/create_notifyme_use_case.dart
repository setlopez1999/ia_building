import 'package:tvapp/core/domain/entities/notifyme/notifyme_entity.dart';
import 'package:tvapp/core/domain/repositories/notification_repository.dart';

class CreateNotifymeUseCase {

  CreateNotifymeUseCase(this._notificationsRepository);

  final NotificationRepository _notificationsRepository;

  Future<void> execute(NotifymeEntity notify) async {
    await _notificationsRepository.createNotification(notify);
  }

}