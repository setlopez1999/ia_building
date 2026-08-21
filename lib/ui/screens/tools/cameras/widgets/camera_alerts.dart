import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/domain/entities/tools/camera_event_entity.dart';
import 'package:tvapp/core/services/alert_scheduler_service.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CameraAlerts extends ConsumerStatefulWidget {
  const CameraAlerts(this.parent, {super.key, this.onClose});

  final CameraEntity parent;
  final VoidCallback? onClose;

  @override
  ConsumerState<CameraAlerts> createState() => _CameraAlertsState();
}

/// Convierte un timestamp UTC a hora Perú (America/Lima, UTC-5, sin DST).
/// Las cámaras y el filtro de horario operan en hora Perú independientemente
/// de la zona horaria del teléfono.
DateTime _peruTime(DateTime utc) {
  return utc.toUtc().subtract(const Duration(hours: 5));
}

/// Combina un evento de inicio con su fin en un solo movimiento registrado.
class _CombinedMotion {
  final CameraEventEntity inicio;
  final CameraEventEntity? fin;
  final String video;

  _CombinedMotion({required this.inicio, this.fin, required this.video});

  String get duracionText => fin != null && fin!.duracion > 0 ? '${fin!.duracion}s' : '—';

  /// Usa el campo 'utc' siempre que sea posible (es correcto) y lo expresa
  /// en hora Perú. El campo 'unix' puede estar desfasado en eventos viejos.
  DateTime get inicioDt {
    if (inicio.utc.isNotEmpty) {
      try {
        return _peruTime(DateTime.parse(inicio.utc));
      } catch (_) {}
    }
    return _peruTime(DateTime.fromMillisecondsSinceEpoch(inicio.unix * 1000, isUtc: true));
  }

  DateTime? get finDt {
    if (fin == null) return null;
    if (fin!.utc.isNotEmpty) {
      try {
        return _peruTime(DateTime.parse(fin!.utc));
      } catch (_) {}
    }
    return _peruTime(DateTime.fromMillisecondsSinceEpoch(fin!.unix * 1000, isUtc: true));
  }
}

/// Combina pares inicio/fin (ignora 'monitoreo').
List<_CombinedMotion> _combineMotions(List<CameraEventEntity> events) {
  final combined = <_CombinedMotion>[];
  CameraEventEntity? pendingInicio;
  for (final event in events) {
    if (event.tipo == 'monitoreo') continue;
    if (event.tipo == 'inicio') {
      pendingInicio = event;
    } else if (event.tipo == 'fin' && pendingInicio != null) {
      combined.add(_CombinedMotion(
        inicio: pendingInicio,
        fin: event,
        video: event.video.isNotEmpty ? event.video : pendingInicio.video,
      ));
      pendingInicio = null;
    }
  }
  return combined;
}

/// Filtra movimientos combinados por horario y días configurados.
/// Usa el tiempo del `inicio` para determinar si el movimiento está en el rango.
List<_CombinedMotion> _filterMotionsBySchedule(List<_CombinedMotion> motions, {required bool enabled, required TimeOfDay startTime, required TimeOfDay endTime, required Set<int> selectedDays}) {
  if (!enabled) return motions;
  final startMin = startTime.hour * 60 + startTime.minute;
  final endMin = endTime.hour * 60 + endTime.minute;
  return motions.where((m) {
    final dt = m.inicioDt;
    final weekday = dt.weekday - 1; // Lunes=0 ... Domingo=6
    if (!selectedDays.contains(weekday)) return false;
    final minuteOfDay = dt.hour * 60 + dt.minute;
    return minuteOfDay >= startMin && minuteOfDay < endMin;
  }).toList();
}

class _CameraAlertsState extends ConsumerState<CameraAlerts> {
  bool _loading = true;
  bool _editing = false;

  // Estado de la config
  bool _enabled = false;
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 59);
  Set<int> _selectedDays = {0, 1, 2, 3, 4, 5, 6};
  int _preAlertMinutes = 5;

  static const _dayNames = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'];

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await AlertSchedulerService.loadConfig(widget.parent.serial);
    if (config != null && mounted) {
      setState(() {
        _enabled = config.enabled;
        _startTime = TimeOfDay(hour: config.startHour, minute: config.startMinute);
        _endTime = TimeOfDay(hour: config.endHour, minute: config.endMinute);
        _selectedDays = config.days.toSet();
        _preAlertMinutes = config.preAlertMinutes;
        _loading = false;
      });
    } else if (mounted) {
      setState(() => _loading = false);
    }
  }

  /// Activa/desactiva la detección de movimientos.
  Future<void> _toggleEnabled(bool value) async {
    setState(() {
      _enabled = value;
      if (!value) _editing = false;
    });
    final config = AlertConfig(
      enabled: value,
      startHour: _startTime.hour,
      startMinute: _startTime.minute,
      endHour: _endTime.hour,
      endMinute: _endTime.minute,
      days: _selectedDays.toList()..sort(),
      preAlertMinutes: _preAlertMinutes,
      serial: widget.parent.serial,
    );
    await AlertSchedulerService.saveConfig(config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Detección de movimientos activada' : 'Detección de movimientos desactivada'),
          backgroundColor: value ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  Future<void> _saveConfig() async {
    final config = AlertConfig(
      enabled: _enabled,
      startHour: _startTime.hour,
      startMinute: _startTime.minute,
      endHour: _endTime.hour,
      endMinute: _endTime.minute,
      days: _selectedDays.toList()..sort(),
      preAlertMinutes: _preAlertMinutes,
      serial: widget.parent.serial,
    );
    await AlertSchedulerService.saveConfig(config);
    if (mounted) {
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horario de detección guardado'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: ThemeData.dark(),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(color: Colors.white24),
          Expanded(
            child: _enabled
                ? (_editing ? _buildEditor() : _buildActiveView())
                : _buildDisabledView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const GoogleTextWidget(
            'Detección de movimientos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              // Botón circular de activar/desactivar
              IconButton(
                onPressed: () => _toggleEnabled(!_enabled),
                icon: Icon(
                  _enabled ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: _enabled ? Colors.greenAccent : Colors.white24,
                  size: 32,
                ),
              ),
              // Botón para volver a configurar las alarmas programadas
              if (_enabled)
                IconButton(
                  onPressed: () => setState(() => _editing = true),
                  icon: const Icon(Icons.settings, color: Colors.white, size: 24),
                ),
              if (widget.onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 24),
                  onPressed: widget.onClose,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.motion_photos_off, color: Colors.white24, size: 64),
          const SizedBox(height: 16),
          const GoogleTextWidget(
            'Detección de movimientos desactivada',
            style: TextStyle(fontSize: 15, color: Colors.white60),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const GoogleTextWidget(
            'Actívala para programar horarios y recibir notificaciones.',
            style: TextStyle(fontSize: 12, color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryTile(),
        const SizedBox(height: 16),
        const GoogleTextWidget(
          'Movimientos detectados',
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 8),
        _buildEventsList(),
      ],
    );
  }

  Widget _buildSummaryTile() {
    final start = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final end = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';
    final daysText = _selectedDays.isEmpty
        ? 'Ningún día'
        : _selectedDays.length == 7
            ? 'Todos los días'
            : _selectedDays.map((d) => _dayNames[d]).join(' ');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 8),
              GoogleTextWidget(
                'Horario: $start - $end',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GoogleTextWidget(
            'Días: $daysText',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          GoogleTextWidget(
            'Pre-alerta: $_preAlertMinutes min antes',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _editing = true),
              icon: const Icon(Icons.tune, size: 18),
              label: const GoogleTextWidget(
                'Volver a configurar',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const GoogleTextWidget(
          'Programar detección',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        _buildTimePicker('Hora de inicio', _startTime, () => _pickTime(true)),
        const SizedBox(height: 16),
        _buildTimePicker('Hora de fin', _endTime, () => _pickTime(false)),
        const SizedBox(height: 24),

        const GoogleTextWidget(
          'Días de la semana',
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (i) => _buildDayButton(i)),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _saveConfig,
            icon: const Icon(Icons.save),
            label: const GoogleTextWidget(
              'Guardar configuración',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList() {
    final eventsAsync = ref.watch(cameraAlertEventsProvider(widget.parent.motionLogUrl));
    return eventsAsync.when(
      data: (events) {
        // Combinar pares inicio+fin primero, luego filtrar por horario.
        final allMotions = _combineMotions(events);
        final motions = _filterMotionsBySchedule(
          allMotions,
          enabled: _enabled,
          startTime: _startTime,
          endTime: _endTime,
          selectedDays: _selectedDays,
        );
        if (motions.isEmpty) {
          if (allMotions.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: GoogleTextWidget(
                'No hay movimientos registrados',
                style: TextStyle(fontSize: 12, color: Colors.white38),
                textAlign: TextAlign.center,
              ),
            );
          }
          final start = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
          final end = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';
          final daysText = _selectedDays.isEmpty
              ? 'sin días seleccionados'
              : _selectedDays.length == 7
                  ? 'todos los días'
                  : _selectedDays.map((d) => _dayNames[d]).join(' ');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: GoogleTextWidget(
              'Hay ${allMotions.length} movimientos, pero ninguno entre '
              '$start-$end los días: $daysText',
              style: const TextStyle(fontSize: 12, color: Colors.white38),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Column(
          children: motions.reversed.take(20).map((m) {
            final inicio = m.inicioDt;
            final h = inicio.hour.toString().padLeft(2, '0');
            final min = inicio.minute.toString().padLeft(2, '0');
            final day = inicio.day.toString().padLeft(2, '0');
            final month = inicio.month.toString().padLeft(2, '0');
            final timeText = '$h:$min';
            final dateText = '$day/$month/${inicio.year}';
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.warning_amber_rounded, size: 24, color: Colors.amber),
              ),
              title: GoogleTextWidget(
                'Movimiento detectado - ${m.duracionText}',
                style: const TextStyle(fontSize: 13, color: Colors.amber),
              ),
              subtitle: GoogleTextWidget(
                '$dateText · $timeText',
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
              onTap: m.video.isNotEmpty
                  ? () {
                      final newCamera = widget.parent.copyWith(isEvent: true, hls: m.video);
                      context.push('/tools/cameras/event-player', extra: newCamera);
                    }
                  : null,
            );
          }).toList(),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: Colors.blue)),
      ),
      error: (err, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: GoogleTextWidget(
          'Error al cargar movimientos: $err',
          style: const TextStyle(fontSize: 12, color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, VoidCallback onTap) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GoogleTextWidget(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            GoogleTextWidget('$hour:$minute', style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton(int dayIndex) {
    final selected = _selectedDays.contains(dayIndex);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            _selectedDays.remove(dayIndex);
          } else {
            _selectedDays.add(dayIndex);
          }
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.white12,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: GoogleTextWidget(
            _dayNames[dayIndex],
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
