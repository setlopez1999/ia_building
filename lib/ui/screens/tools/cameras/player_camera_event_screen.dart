import 'dart:async';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/core/services/native_player_control_service.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/event_controls.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PlayerCameraEventScreen extends ConsumerStatefulWidget {

  const PlayerCameraEventScreen({super.key, required this.stream});
  static const name = 'PlayerCameraEventScreen';

  final CameraEntity stream;

  @override
  ConsumerState<PlayerCameraEventScreen> createState() => _PlayerCameraEventScreenState();
}

class _PlayerCameraEventScreenState extends ConsumerState<PlayerCameraEventScreen> {
  BetterPlayerController? _controller;
  bool _hasError = false;
  Timer? _orientationTimer;

  @override
  void initState() {
    super.initState();
    if (widget.stream.fromLivePlayer) {
      // Silencia el audio del tiempo real mientras se ve el evento.
      NativePlayerControlService.mute();
    }
    _enableListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializePlayer());
    // Re-aplica landscape periodicamente para que ninguna pantalla de la base
    // (p. ej. InitialLoader en cold start) pueda revertirlo a vertical.
    _orientationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _enableListeners();
  }

  void _enableListeners() {
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initializePlayer() async {
    _hasError = false;
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.stream.hls,
    );

    final controller = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
        allowedScreenSleep: false,
      ),
      betterPlayerDataSource: dataSource,
    );

    controller.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.exception && mounted) {
        setState(() => _hasError = true);
      }
    });

    if (mounted) setState(() => _controller = controller);
  }

  @override
  void dispose() {
    _orientationTimer?.cancel();
    _controller?.removeEventsListener((_) {});
    _controller?.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (widget.stream.fromLivePlayer) {
      // Vuelve al player en tiempo real (siempre horizontal). No habilitar
      // portrait en ningún momento para evitar el parpadeo vertical.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Restaura el audio del tiempo real al salir del evento.
      NativePlayerControlService.unmute();
    } else {
      // Vino de una notificación: restaurar todas las orientaciones.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    super.dispose();
  }

  void _onBack() {
    context.pop();
  }

  void _seekRelative(int seconds) {
    final pos = _controller?.videoPlayerController?.value.position;
    if (pos == null) return;
    final newPos = pos + Duration(seconds: seconds);
    _controller?.seekTo(newPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildPlayer(),
          ),
          CameraEventControls(
            onBack: _onBack,
            onRewind: () => _seekRelative(-10),
            onForward: () => _seekRelative(10),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text('Error al reproducir el video', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _controller?.dispose();
                  _controller = null;
                });
                _initializePlayer();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_controller == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.amber),
            SizedBox(height: 16),
            Text('Cargando video...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    return BetterPlayer(controller: _controller!);
  }
}
