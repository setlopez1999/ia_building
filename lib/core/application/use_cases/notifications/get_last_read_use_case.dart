import 'package:tvapp/core/domain/repositories/notification_repository.dart';

class GetLastReadUseCase {
  GetLastReadUseCase(this._notificationsRepository);

  final NotificationRepository _notificationsRepository;

  Future<String> execute() async {
    return _notificationsRepository.getLastDateRead();
  }
}
