import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/core/domain/repositories/notification_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetNotificationsUseCase {
  GetNotificationsUseCase(this._notificationsRepository);

  final NotificationRepository _notificationsRepository;

  Future<Either<AppException, List<NotificationEntity>>> execute(String userId) {
    return _notificationsRepository.getNotifications(userId);
  }
}
