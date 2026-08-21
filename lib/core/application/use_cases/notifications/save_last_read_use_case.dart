import 'package:tvapp/core/domain/repositories/notification_repository.dart';

class SaveLastReadUseCase {
  SaveLastReadUseCase(this._notificationsRepository);

  final NotificationRepository _notificationsRepository;

  Future<void> execute(String date) async {
    await _notificationsRepository.saveLastDateRead(date);
  }
}
