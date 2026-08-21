import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/ui/providers/notification/notifications_provider.dart';
import 'package:tvapp/ui/screens/notifications/notifications.screen.dart';

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

  int calcUnreadNotifications(List<NotificationEntity> notifications) {
    return notifications.where((element) => element.read != 1)
        .toList()
        .length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final notificationsState = ref.watch(notificationsProvider);

    return notificationsState.maybeWhen(
        success: (notifications) {
          final newNotification = calcUnreadNotifications(notifications);
          return IconButton(
            onPressed: () {
              context.pushNamed(NotificationsScreen.name);
            },
            icon: Badge(
              isLabelVisible: newNotification > 0,
              label: Text(newNotification.toString(),
                  style: const TextStyle(fontSize: 14)),
              child: SvgPicture.asset(
                'assets/icons/notifications.svg',
                width: 27,
                height: 27,
                colorFilter: ColorFilter.mode(
                  AppTheme.textColor(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
            color: AppTheme.textColor(context),
          );
        },
        initial: () {
          Future.microtask((){
            ref.read(notificationsProvider.notifier).getNotifications();
          });
          return const SizedBox();
        },
        orElse: SizedBox.new
    );
  }
}
