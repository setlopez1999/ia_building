import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/domain/entities/tools/camera_event_entity.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class _CombinedEvent {

  _CombinedEvent({required this.inicio, this.fin, required this.video});
  final CameraEventEntity inicio;
  final CameraEventEntity? fin;
  final String video;

  String get duracionText => fin != null && fin!.duracion > 0 ? '${fin!.duracion}s' : '—';
  String get inicioTime => _formatUtc(inicio.utc);
  String get finTime => fin != null ? _formatUtc(fin!.utc) : '—';
  int get unix => inicio.unix;
}

String _formatUtc(String utc) {
  try {
    final dt = DateTime.parse(utc).toLocal();
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    return '$day/$month/$year $h:$m:$s';
  } catch (_) {
    return utc;
  }
}

List<_CombinedEvent> _combineEvents(List<CameraEventEntity> events) {
  final combined = <_CombinedEvent>[];
  CameraEventEntity? pendingInicio;
  for (final event in events) {
    if (event.tipo == 'monitoreo') continue;
    if (event.tipo == 'inicio') {
      pendingInicio = event;
    } else if (event.tipo == 'fin' && pendingInicio != null) {
      combined.add(_CombinedEvent(
        inicio: pendingInicio,
        fin: event,
        video: event.video.isNotEmpty ? event.video : pendingInicio.video,
      ));
      pendingInicio = null;
    }
  }
  return combined;
}

class CameraEvents extends ConsumerStatefulWidget {
  const CameraEvents(this.parent, {super.key});

  final CameraEntity parent;

  @override
  ConsumerState<CameraEvents> createState() => _CameraEventsState();
}

class _CameraEventsState extends ConsumerState<CameraEvents> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(cameraEventsProvider(widget.parent.motionLogUrl));
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) {
        ref.invalidate(cameraEventsProvider(widget.parent.motionLogUrl));
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(cameraEventsProvider(widget.parent.motionLogUrl));
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(cameraEventsProvider(widget.parent.motionLogUrl));

    return Scaffold(
      backgroundColor: Colors.black,
      body: eventsAsync.when(
        data: (events) {
          final combined = _combineEvents(events).reversed.toList();
          if (combined.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sin eventos de movimiento', style: TextStyle(color: Colors.white60)),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _refresh,
                  ),
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                      onPressed: _refresh,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemCount: combined.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.transparent,
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      final item = combined[index];
                      return _CombinedEventTile(item: item, parent: widget.parent);
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.blue)),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $e', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _refresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CombinedEventTile extends StatelessWidget {

  const _CombinedEventTile({required this.item, required this.parent});
  final _CombinedEvent item;
  final CameraEntity parent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(12),
        child: const Icon(Icons.warning_amber_rounded, size: 32, color: Colors.amber),
      ),
      title: GoogleTextWidget(
        'Movimiento detectado - ${item.duracionText}',
        style: const TextStyle(fontSize: 16, color: Colors.amber),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GoogleTextWidget(
            'Inicio: ${item.inicioTime}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          if (item.fin != null)
            GoogleTextWidget(
              'Fin:    ${item.finTime}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
        ],
      ),
      onTap: item.video.isNotEmpty
          ? () {
              final newCamera = parent.copyWith(
                isEvent: true,
                hls: item.video,
                fromLivePlayer: true,
              );
              context.push('/tools/cameras/event-player', extra: newCamera);
            }
          : null,
    );
  }
}
