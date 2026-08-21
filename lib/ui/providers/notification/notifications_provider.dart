import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/notifications/get_notifications_use_case.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/connectivity/internet_check_provider.dart';

part 'notifications_provider.g.dart';

@Riverpod(keepAlive: true)
class Notifications extends _$Notifications {
  Timer? _timer;

  @override
  ContentState<List<NotificationEntity>> build() {
    _startMonitoring();

    ref.onDispose(() {
      _timer?.cancel();
    });

    return const ContentState.initial();
  }

  void _startMonitoring() {
    _timer?.cancel();

    if(Environment.notificationsEnabled ){
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        getNotifications();
      });
    }
  }

  Future<void> getNotifications() async {
    final connected = await ref
        .read(internetCheckProvider.notifier)
        .checkConnectivity();

    if (!connected) {
      print("Sin conexión, no se consultan notificaciones.");
      return;
    }

    final authState = ref.read(authProvider);

    final user = authState.maybeWhen(
      success: (user) => user,
      orElse: () => null,
    );

    if (user == null) return;

    final useCase = GetNotificationsUseCase(ref.read(notificationRepositoryProvider));

    final result = await useCase.execute(user.us_id);

    state = result.fold(
          (err) => ContentState.error(err),
          (data) => ContentState.success(data),
    );
  }

  int getUnreadNotificationsCount() {
    return state.maybeWhen(
      success: (notifications) =>
      notifications.where((n) => n.read != 1).length,
      orElse: () => 0,
    );
  }
}
