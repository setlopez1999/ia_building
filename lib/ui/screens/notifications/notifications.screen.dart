import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/ui/providers/notification/notifications_provider.dart';
import 'package:tvapp/ui/providers/notification_selected/notification_selected_provider.dart';
import 'package:tvapp/ui/screens/notification_detail/notification_detail_screen.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static String name = 'Notifications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);

    return notificationsState.maybeWhen(
        success: (notifications) {
          return Scaffold(
            appBar: customAppBar(context, title: 'Notificaciones'),
            body: notifications.isEmpty
                ? const Center(
                    child: GoogleTextWidget(
                      'No tienes notificaciones',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemBuilder: (context, index) {
                        final NotificationEntity notification =
                            notifications[index];
                        return ListTile(
                          onTap: () {
                            ref.read(notificationSelectedProvider.notifier).setNotification(notification);
                            context.pushNamed(NotificationDetailScreen.name);
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${Environment.baseHost}/${notification.image_url}',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.notifications, size: 40),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GoogleTextWidget(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: notification.read == 0 ? AppTheme.textColor(context) : Colors.white38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: GoogleTextWidget(
                            notification.text,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12,
                              color: notification.read == 0 ? AppTheme.textColor(context) : Colors.white38,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: GoogleTextWidget(DateFormat('dd/MM').format(
                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                .parse(notification.created_at),
                          ),style: TextStyle(
                              fontSize: 14,
                              color: notification.read == 0 ? AppTheme.textColor(context) : Colors.white38,
                          ),
                          ),
                        );
                      },
                      itemCount: notifications.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: Colors.white38,
                        );
                      },
                    ),
                ),
          );
        },
        initial: () {
          Future.microtask((){
            ref.read(notificationsProvider.notifier).getNotifications();
          });
          return const SizedBox();
        },
        orElse: () => const SizedBox());
  }
}
