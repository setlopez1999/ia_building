import 'dart:async';
import 'dart:io';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:tvapp/core/domain/entities/tools/camera_entity.dart';
import 'package:tvapp/ui/providers/tools/camera_providers.dart';
import 'package:tvapp/ui/screens/player/player_brightness.dart';
import 'package:tvapp/ui/screens/player/player_enums.dart';
import 'package:tvapp/ui/screens/player/widgets/chromecast_loader.dart';
import 'package:tvapp/ui/screens/player/widgets/chromecast_selector.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/camera_alerts.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/camera_controls.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/camera_events.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/camera_grid.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/camera_list.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/dpad.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/info.dart';
import 'package:tvapp/ui/screens/tools/cameras/widgets/native_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PlayerCamerasScreen extends ConsumerStatefulWidget {
  const PlayerCamerasScreen({super.key});

  static String name = 'PlayerCameras';

  @override
  ConsumerState createState() => _PlayerCamerasScreenState();
}

class _PlayerCamerasScreenState extends ConsumerState<PlayerCamerasScreen> {

  static const _eventChannel = EventChannel('tv.oneplay.app/playerEvents');

  Timer? _timerHideInfo;
  Timer? _orientationTimer;
  PlayerSteps _step = PlayerSteps.controls;
  PlayerStatus playerStatus = PlayerStatus.buffering;
  double _illumination = 1;
  double _volume = 0;
  late Floating floating;
  bool _canUsePip = false;
  late StreamSubscription _playerEventsSub;
  GoogleCastConnectState castConnectionState = GoogleCastConnectState.disconnected;

  @override
  void initState() {
    WakelockPlus.enable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // Re-aplica landscape periodicamente: al volver del reproductor de
    // eventos (que al hacer pop restaura todas las orientaciones) la pantalla
    // de tiempo real debe mantenerse horizontal, no vertical.
    _orientationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      }
    });

    _scheduleHideInfo();

    VolumeController.instance.addListener((volume)=>setState(() => _volume = volume));
    PlayerBrightness().loadBrightness().then((value) {
      ScreenBrightness.instance.setApplicationScreenBrightness(value);
      setState(()=> _illumination = value);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(Platform.isAndroid) {
        floating = Floating();
        _canUsePip = await floating.isPipAvailable;
      }
      initPlatformState();
      listenToChromecastEvents();
      setState(() {});
    });

    _playerEventsSub =_eventChannel.receiveBroadcastStream().listen((dynamic event) {
      if(!mounted) return;

      if (event is Map) {
        final mapEvent = Map<String, dynamic>.from(event);
        if(mapEvent['event'] == 'state') {
          final status = mapEvent['value'];
          if(status == 'idle') {
            setState(() => playerStatus = PlayerStatus.buffering);
          } else if(status == 'buffering') {
            setState(() => playerStatus = PlayerStatus.buffering);
          } else if(status == 'ready') {
            setState(() => playerStatus = PlayerStatus.playing);
          }else {
            setState(() => playerStatus = PlayerStatus.error);
          }
        }

        if(mapEvent['event'] == 'error') {
          setState(() => playerStatus = PlayerStatus.error);
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _orientationTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    _timerHideInfo?.cancel();
    VolumeController.instance.removeListener();
    _playerEventsSub.cancel();
    GoogleCastSessionManager.instance.endSessionAndStopCasting();
    super.dispose();
  }

  /// Inicializa el contexto de Google Cast con el App ID por defecto.
  void initPlatformState() {
    if (Platform.isAndroid) {
      const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
      final options = GoogleCastOptionsAndroid(appId: appId);
      GoogleCastContext.instance.setSharedInstanceWithOptions(options);
    }
  }

  Future<void> connectToChromecastDevice(GoogleCastDevice device) async {
    await GoogleCastSessionManager.instance.startSessionWithDevice(device);
    await GoogleCastSessionManager.instance.currentSessionStream.firstWhere(
      (conn) => conn?.connectionState == GoogleCastConnectState.connected,
    );
    await GoogleCastDiscoveryManager.instance.stopDiscovery();
    final camera = ref.read(cameraSelectedProvider);
    if (camera != null) {
      await _launchCameraOnChromeCast(camera);
    }
  }

  /// Reproduce la cámara en el Chromecast usando HLS en vivo (el Chromecast no
  /// soporta SRT). Si no hay HLS, no hace nada. Si la URL apunta al DVR
  /// (playlist_dvr.m3u8) la convierte a la playlist en vivo para que la TV
  /// muestre tiempo real y no el inicio del archivo grabado.
  Future<void> _launchCameraOnChromeCast(CameraEntity camera) async {
    var hlsUrl = camera.hls;
    if (hlsUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Esta cámara no tiene HLS disponible para TV')),
        );
      }
      return;
    }
    hlsUrl = hlsUrl.replaceAll('playlist_dvr.m3u8', 'playlist.m3u8');
    await GoogleCastRemoteMediaClient.instance.queueLoadItems(
      [
        GoogleCastQueueItem(
          mediaInformation: GoogleCastMediaInformationAndroid(
            contentId: camera.id,
            streamType: CastMediaStreamType.live,
            contentType: 'application/x-mpegurl',
            contentUrl: Uri.parse(hlsUrl),
            hlsSegmentFormat: CastHlsSegmentFormat.ts,
            hlsVideoSegmentFormat: HlsVideoSegmentFormat.mpeg2Ts,
            metadata: GoogleCastMovieMediaMetadata(
              title: camera.name,
              studio: 'Cámara ${camera.id}',
              releaseDate: DateTime.now(),
            ),
          ),
        ),
      ],
      options: GoogleCastQueueLoadOptions(),
    );
  }

  void listenToChromecastEvents() {
    GoogleCastRemoteMediaClient.instance.mediaStatusStream.listen((event) {
      if (!mounted) return;
      switch (event?.playerState) {
        case CastMediaPlayerState.loading:
        case CastMediaPlayerState.buffering:
          setState(() => playerStatus = PlayerStatus.buffering);
          break;
        case CastMediaPlayerState.playing:
          setState(() => playerStatus = PlayerStatus.playing);
          break;
        case CastMediaPlayerState.idle:
          if (event?.idleReason == GoogleCastMediaIdleReason.error) {
            setState(() => playerStatus = PlayerStatus.error);
          }
          break;
        default:
          break;
      }
    });

    GoogleCastSessionManager.instance.currentSessionStream.listen((event) {
      if (!mounted) return;
      if (event?.connectionState == GoogleCastConnectState.connecting) {
        setState(() => _step = PlayerSteps.chromecastLoading);
      } else {
        setState(() {
          castConnectionState = event?.connectionState ?? GoogleCastConnectState.disconnected;
        });
      }
    });
  }

  void _scheduleHideInfo() {
    _timerHideInfo?.cancel();

    _timerHideInfo = Timer(const Duration(seconds: 10), () {
      if(!mounted) return;
      // No auto-ocultar paneles laterales de cámara (alertas, eventos, lista, grid, info)
      if (_step == PlayerSteps.cameraAlert ||
          _step == PlayerSteps.cameraEvents ||
          _step == PlayerSteps.cameraList ||
          _step == PlayerSteps.cameraGrid ||
          _step == PlayerSteps.cameraInfo) return;
      setState(() {
        _step = PlayerSteps.none;
      });
    });
  }

  Widget casePlaying(BuildContext context, CameraEntity camera) {
    return AbsorbPointer(
      child: NativePlayer(camera: camera, muted: _step == PlayerSteps.cameraGrid),
    );
  }

  Widget content(BuildContext context, CameraEntity camera,
      {bool dpadEnabled = true}) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Listener(
        onPointerDown: (_) => _scheduleHideInfo(),
        child: SafeArea(
          top: false,
          right: false,
          left: false,
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Stack(
                children: [
                  Positioned(
                    right: 0,
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                        onTap: () {
                          setState(() => _step = PlayerSteps.controls );
                        },
                        child: casePlaying(context ,camera)
                    ),
                  ),

                  if(_step == PlayerSteps.none && dpadEnabled && camera.onvifApiUrl.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: const DPad(),
                    )
                ],
              ),

              if(playerStatus == PlayerStatus.buffering)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text('Conectando con la cámara', style: TextStyle(color: Colors.white),),
                  ),
                ),
              if(playerStatus == PlayerStatus.error)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text('Error al conectar con la cámara', style: TextStyle(color: Colors.white),),
                  ),
                ),

              if(_step == PlayerSteps.controls)
                Positioned.fill(
                    child: AnimatedOpacity(
                        opacity: _step == PlayerSteps.controls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: CameraControls(
                          illumination: _illumination,
                          canUsePip: _canUsePip,
                          onPipPressed: () async {
                            if(_canUsePip && Platform.isAndroid) {
                              await floating.enable(const ImmediatePiP());
                            }
                          },
                          onTvPressed: () async {
                            if (castConnectionState == GoogleCastConnectState.connected) {
                              await GoogleCastSessionManager.instance.endSessionAndStopCasting();
                              setState(() {
                                castConnectionState = GoogleCastConnectState.disconnected;
                                _step = PlayerSteps.none;
                              });
                              return;
                            }
                            await GoogleCastDiscoveryManager.instance.startDiscovery();
                            setState(() {
                              _timerHideInfo?.cancel();
                              _step = PlayerSteps.chromecastSelector;
                            });
                          },
                          volume: _volume,
                          onPressed: () => setState(() => _step = PlayerSteps.none),
                          onInfoPressed: () => setState(() => _step = PlayerSteps.cameraInfo),
                          onListPressed: () => setState(() => _step = PlayerSteps.cameraList),
                          onGridPressed: () => setState(() => _step = PlayerSteps.cameraGrid),
                          onEventsPressed: () => setState(() => _step = PlayerSteps.cameraEvents),
                          onAlertPressed: () => setState(() => _step = PlayerSteps.cameraAlert),
                          onBrightnessChanged: (value) async {
                            if (mounted) {
                              await ScreenBrightness.instance.setApplicationScreenBrightness(value);
                              await PlayerBrightness().saveBrightness(value);
                              setState(() {
                                _illumination = value;
                              });
                            }
                          },
                          onVolumeChanged: (value) {
                            VolumeController.instance.showSystemUI = false;
                            setState(() {
                              _volume = value;
                              VolumeController.instance.setVolume(_volume);
                            });
                          },
                        )
                    )
                ),

              if(_step == PlayerSteps.cameraInfo)
                Info(onBackPressed: () => setState(() => _step = PlayerSteps.controls)),

              if(_step == PlayerSteps.cameraList)
                const AnimatedPositioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    width: 350,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: CameraList()
                ),

              if(_step == PlayerSteps.cameraGrid)
                AnimatedPositioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: CameraGrid(onClose: () => setState(() => _step = PlayerSteps.controls))
                ),

              if(_step == PlayerSteps.cameraEvents)
                AnimatedPositioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    width: 350,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: CameraEvents(camera)
                ),

              if(_step == PlayerSteps.cameraAlert)
                AnimatedPositioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    width: 350,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: CameraAlerts(camera, onClose: () => setState(() => _step = PlayerSteps.controls))
                ),

              if(_step == PlayerSteps.chromecastSelector)
                ChromecastSelector(
                  onClosed: () {
                    setState(() {
                      _step = PlayerSteps.none;
                    });
                  },
                  onSelect: (device) {
                    setState(() {
                      _step = PlayerSteps.none;
                    });
                    connectToChromecastDevice(device);
                  },
                ),

              if(_step == PlayerSteps.chromecastLoading)
                const ChromecastLoader(),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final camera = ref.watch(cameraSelectedProvider);

    if(camera == null ) {
      return const Scaffold(
        body: Center(
          child: Text('No hay cámara seleccionada', style: TextStyle(color: Colors.white),),
        ),
      );
    }

    if(Platform.isAndroid) {
      return PiPSwitcher(
        childWhenDisabled: content(context, camera),
        childWhenEnabled: AspectRatio(
          aspectRatio: 16/9,
          child: content(context, camera, dpadEnabled: false),
        )
      );
    }

    return content(context, camera);
  }
}
