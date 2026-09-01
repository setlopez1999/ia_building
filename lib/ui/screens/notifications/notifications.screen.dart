import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/domain/entities/notification/notification_entity.dart';
import 'package:tvapp/ui/providers/notification/notifications_provider.dart';
import 'package:tvapp/ui/providers/notification_selected/notification_selected_provider.dart';
import 'package:tvapp/ui/screens/notification_detail/notification_detail_screen.dart';
import 'package:tvapp/ui/shared/widgets/api_state.widget.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

/// El servidor puede mandar la imagen como ruta relativa o como URL completa
/// (y el valor por defecto de la entidad es una URL completa). Anteponer el
/// host a una URL completa la rompe, por eso solo se antepone si hace falta.
String notificationImageUrl(String raw) {
  final url = raw.trim();
  if (url.isEmpty) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  return '${Environment.baseHost}/$url';
}

/// Imagen de la notificación con un marcador visible cuando no hay imagen o
/// falla la carga. Antes el respaldo era un icono sin color, que sobre el
/// fondo oscuro se veia como una mancha negra.
class NotificationImage extends StatelessWidget {
  const NotificationImage({
    super.key,
    required this.url,
    this.size = 56,
    this.dimmed = false,
  });

  final String url;
  final double size;

  /// Las notificaciones leidas se ven atenuadas, igual que su texto.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final resolved = notificationImageUrl(url);

    // Los logos de canal son PNG transparentes pensados para fondo claro, por
    // eso la tarjeta es blanca y la imagen va `contain`, igual que en la lista
    // de canales de IPTV.
    final vacio = Icon(
      Icons.notifications_none,
      size: size * 0.45,
      color: Colors.black26,
    );

    return Opacity(
      opacity: dimmed ? 0.45 : 1,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: resolved.isEmpty
            ? vacio
            : Image.network(
                resolved,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => vacio,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : vacio,
              ),
      ),
    );
  }
}

/// Pestañas del maquetado. Hoy solo existe una: la respuesta del API no trae
/// ningún campo que permita separar Canales / Eventos / Cámaras. Cuando el
/// backend mande ese dato, se agregan acá y se filtra en [_filtrar].
enum NotificationTab {
  canales('Canales');

  const NotificationTab(this.label);
  final String label;
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  static String name = 'Notifications';

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationTab _tab = NotificationTab.canales;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    await ref.read(notificationsProvider.notifier).getNotifications();
  }

  /// Punto único de filtrado por pestaña. Hoy devuelve todo porque no hay
  /// criterio; cuando exista, se filtra acá y el resto no cambia.
  List<NotificationEntity> _filtrar(List<NotificationEntity> todas) {
    switch (_tab) {
      case NotificationTab.canales:
        return todas;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsProvider);

    // El Scaffold va siempre: antes toda la pantalla se reemplazaba por un
    // SizedBox vacío y el usuario se quedaba sin barra para volver.
    return Scaffold(
      appBar: customAppBar(context, title: 'Notificaciones'),
      body: Column(
        children: [
          _TabBar(
            active: _tab,
            onTap: (tab) => setState(() => _tab = tab),
          ),
          Expanded(
            child: ApiStateView<List<NotificationEntity>>(
              state: notificationsState,
              onRetry: _load,
              emptyMessage: 'No tienes notificaciones',
              builder: (todas) {
                final notifications = _filtrar(todas);
                if (notifications.isEmpty) {
                  return const Center(
                    child: GoogleTextWidget(
                      'No tienes notificaciones en esta sección',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return _NotificationsList(notifications: notifications);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.active, required this.onTap});

  final NotificationTab active;
  final ValueChanged<NotificationTab> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: NotificationTab.values.map((tab) {
          final isActive = tab == active;
          return GestureDetector(
            onTap: () => onTap(tab),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? Environment.actionColor
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: GoogleTextWidget(
                tab.label,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white : Colors.white54,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NotificationsList extends ConsumerWidget {
  const _NotificationsList({required this.notifications});

  final List<NotificationEntity> notifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sin separadores: en el diseño las filas se distinguen por el espacio,
    // no por una línea.
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final leida = notification.read != 0;
        final color = leida ? Colors.white38 : AppTheme.textColor(context);

        return InkWell(
          onTap: () {
            ref
                .read(notificationSelectedProvider.notifier)
                .setNotification(notification);
            context.pushNamed(NotificationDetailScreen.name);
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotificationImage(
                  url: notification.image_url,
                  size: 52,
                  dimmed: leida,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoogleTextWidget(
                        notification.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GoogleTextWidget(
                        notification.text,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // La fecha va arriba, a la altura del título.
                GoogleTextWidget(
                  _fecha(notification.created_at),
                  style: TextStyle(fontSize: 13, color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Una fecha con formato inesperado no debe romper la lista entera.
  String _fecha(String raw) {
    try {
      return DateFormat('dd/MM')
          .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(raw));
    } catch (_) {
      return '';
    }
  }
}
