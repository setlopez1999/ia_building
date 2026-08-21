import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/use_cases/auth/get_session_use_case.dart';
import 'package:tvapp/core/application/use_cases/notifications/read_notification_use_case.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/notification/notifications_provider.dart';

part 'notification_selected_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationSelected extends _$NotificationSelected {

  final NotificationEntity? state = null;

  @override
  NotificationEntity? build() => null;

  void setNotification(NotificationEntity notification) {
    state = notification;
  }

  Future<void> markAsRead(NotificationEntity notification) async {
    final sessionUseCase = GetSessionUseCase(ref.read(authRepositoryProvider));

    final session = await sessionUseCase.execute();

    await session.fold((error) => null, (session) async {
      await ReadNotificationUseCase(ref.read(notificationRepositoryProvider)).execute(notification, session.userID);
      await ref.read(notificationsProvider.notifier).getNotifications();
    });
  }

}