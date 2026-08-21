import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/notifyme/notifyme_entity.dart';
import 'package:tvapp/core/domain/repositories/notification_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetNotifymesUseCase {

  GetNotifymesUseCase(this._notificationRepository);

  final NotificationRepository _notificationRepository;

  Future<Either<AppException, List<NotifymeEntity>>> execute() {
    return _notificationRepository.listNotifyme();
  }
}