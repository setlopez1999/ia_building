import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/ui/providers/notification_selected/notification_selected_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class NotificationDetailScreen extends ConsumerWidget {
  const NotificationDetailScreen({super.key});

  static String name = 'NotificationDetail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.read(notificationSelectedProvider);
    ref.read(notificationSelectedProvider.notifier).markAsRead(notification!);
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Notificaciones',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                '${Environment.baseHost}/${notification.image_url}',
                height: 200,
                width: 200,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.notifications, size: 80),
              ),
              const SizedBox(height: 32),
              GoogleTextWidget(
                DateFormat('dd/MM').format(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .parse(notification.created_at),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              GoogleTextWidget(
                notification.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              GoogleTextWidget(
                notification.text,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
