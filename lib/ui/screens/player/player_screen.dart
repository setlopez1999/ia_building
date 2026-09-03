import 'dart:async';
import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';
import 'package:tvapp/core/domain/entities/sensitive_data/sensitive_data_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/channel_playing/channel_playing_provider.dart';
import 'package:tvapp/ui/screens/home/home.screen.dart';
import 'package:tvapp/ui/screens/player/player_brightness.dart';
import 'package:tvapp/ui/screens/player/player_enums.dart';
import 'package:tvapp/ui/screens/player/widgets/catchup.dart';
import 'package:tvapp/ui/screens/player/widgets/catchup_controls.dart';
import 'package:tvapp/ui/screens/player/widgets/channels_menu.dart';
import 'package:tvapp/ui/screens/player/widgets/chromecast_selector.dart';
import 'package:tvapp/ui/screens/player/widgets/controls.dart';
import 'package:tvapp/ui/screens/player/widgets/epg_info.dart';
import 'package:tvapp/ui/screens/player/widgets/player.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/channel_fade.widget.dart';
import 'package:tvapp/ui/shared/widgets/global_text.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'widgets/chromecast_loader.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  static String name = 'PlayerScreen';

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  BetterPlayerController? _videoController;
  SensitiveDataEntity? _sensitiveData;
  PlayerSteps _step = PlayerSteps.controls;
  Epg? epgPlaying;
  double epgPlayingTime = 0;
  Timer? _timerEpgSync;
  bool catchupPlaying = false;
  Timer? _timerHideInfo;
  Timer? _timerSendDataToDashboard;
  Timer? _errorRetryTimer;
  final bool _retrying = false;
  double _volume = 0;
  double _illumination = 1;
  PlayerStatus playerStatus = PlayerStatus.buffering;
  StreamEntity? stream;
  late Floating floating;
  bool _canUsePip = false;
  GoogleCastConnectState castConnectionState = GoogleCastConnectState.disconnected;


  @override
  void initState() {
    //Manteniendo la pantalla encendida
    WakelockPlus.enable();

    //forzando la pantalla horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    _scheduleHideInfo();

    VolumeController.instance.addListener((volume)=>setState(() => _volume = volume));
    PlayerBrightness().loadBrightness().then((value) {
      ScreenBrightness.instance.setApplicationScreenBrightness(value);
      setState(()=> _illumination = value);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authProvider.notifier).getAllUserInfo().then((value) {
        _sensitiveData = value.$2;
      });

      ref.read(channelPlayingProvider).maybeWhen(orElse: (){}, success: (stream){
        setState(() {
          this.stream = stream;
        });
        launchChannel(stream);
      });

      if(Platform.isAndroid) {
        floating = Floating();
        _canUsePip = await floating.isPipAvailable;
      }

      initPlatformState();
      listenToChromecastEvents();

      setState(() {});
    });

    _timerSendDataToDashboard = Timer.periodic(const Duration(seconds: 15), (timer) async {
      await ref.read(channelPlayingProvider.notifier).listenChannelChanges();
    });

    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose(forceDispose: true);
    WakelockPlus.disable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    _timerHideInfo?.cancel();
    _timerSendDataToDashboard?.cancel();
    _errorRetryTimer?.cancel();
    VolumeController.instance.removeListener();
    GoogleCastSessionManager.instance.endSessionAndStopCasting();
    super.dispose();
  }

  Future<void> launchChannel(StreamEntity stream , {bool forceDevice = false}) async {
    catchupPlaying = false;
    epgPlaying = null;
    _timerEpgSync?.cancel();

    if(stream.channel.isAdulto) {
      final result =  await BaseButtonChannel.validateAdultPassword(context, ref, stream);

      if(result != true) {
        BaseButtonChannel.working = false;

        if(stream.cdn == 2) {
          //como no tenemos una propiedad para saber si el evento se origino en el home usaremos la propiedad cdn con valor 2
          //en el json de stream cdn  es 1 o 0 asi que solo es 2 cuando lo definimos manualmente
          //prometo agregar la propiedad mas adelante
          context.pushReplacementNamed(HomeScreen.name);
          return;
        }

        await BaseButtonChannel.toLeft(ref);
        return;
      }
    }


    if(forceDevice) {
      print('Forzando reproduccion en dispositivo');
      launchChannelDevice(stream, force: forceDevice);
      return;
    }

    if(castConnectionState == GoogleCastConnectState.connected) {
      await launchChannelChromeCast(stream);
      return;
    }

    launchChannelDevice(stream, force: forceDevice);
  }

  void launchChannelDevice(StreamEntity stream , {bool force = false}) {
    if (_videoController == null) {
      setState(() => playerStatus = PlayerStatus.buffering);
      initializePlayer(stream.link);
      return;
    }

    if(_videoController?.betterPlayerDataSource?.url == stream.link && !force) {
      return;
    }

    final oldController = _videoController;

    Future.delayed(const Duration(milliseconds: 10), () async {
      oldController?.dispose(forceDispose: true);

      // Initing new controller
      await initializePlayer(stream.link);
    });
  }

  void setCatchup(StreamEntity stream, Epg epg) {
    catchupPlaying = true;
    epgPlaying = epg;
    _timerEpgSync?.cancel();
    _timerEpgSync = Timer.periodic(const Duration(seconds: 1), (t) async{
      final position = await _videoController?.videoPlayerController?.position;
      if(position == null) {
        return;
      }
      final positionTime = position.inSeconds.toDouble();
      setState(() {
        epgPlayingTime = positionTime;
      });
    });

    if(GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected) {
      GoogleCastSessionManager.instance.endSessionAndStopCasting();
    }

    final linkCatchUp = stream.link.split('.m3u8');
    final linkToPlay = '${linkCatchUp[0]}_dvr_range-${epg.fecha_ini}-${epg.run*60}.m3u8';

    if (_videoController == null) {
      initializePlayer(linkToPlay, catchup: true);
      return;
    }

    if(_videoController?.betterPlayerDataSource?.url == linkToPlay) {
      return;
    }

    final oldController = _videoController;
    Future.delayed(const Duration(milliseconds: 10), () async {
      oldController?.dispose(forceDispose: true);

      // Initing new controller
      await initializePlayer(stream.link);
    });
  }

  Future<void> initializePlayer(String link, {bool catchup = false}) async {
    print('Initializing player with $link');
    final userAgentName = Platform.isAndroid ? 'APPMOVIL' : 'APPMOVILIOS';

    _videoController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoDispose: false,
        
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
          showControlsOnInitialize: false
        )
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, link,
        headers: {
          'User-Agent': '$userAgentName-${_sensitiveData!.deviceId}',
        },
      ),
    );

    _videoController?.addEventsListener((event) async {
      if(event.betterPlayerEventType == BetterPlayerEventType.exception) {
        playerStatus = PlayerStatus.error;
        _errorRetryTimer?.cancel();
        _errorRetryTimer = Timer(const Duration(seconds: 2), () {
          print('Retrying to play the channel after error');
          launchChannel(stream!, forceDevice: true);
        });
        setState(() {});
      }

      if(event.betterPlayerEventType == BetterPlayerEventType.play) {
        _errorRetryTimer?.cancel();
        if(playerStatus != PlayerStatus.playing) {
          playerStatus = PlayerStatus.playing;
          setState(() {});
        }
      }
    });

    setState(() {});
    await _videoController?.play();
  }

  void _scheduleHideInfo() {

    _timerHideInfo?.cancel();

    _timerHideInfo = Timer(const Duration(seconds: 10), () {
      setState(() {
        _step = PlayerSteps.none;
      });
    });
  }

  Widget casePlaying(BuildContext context) {
    print(playerStatus.toString());
    if(playerStatus == PlayerStatus.error) {
      
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: GlobalTextWidget('Error al reproducir el canal', style: TextStyle(color: Colors.white)),
            )),
      );
    }

    if(playerStatus == PlayerStatus.buffering) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: const Expanded(
          child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: GlobalTextWidget('Cargando...', style: TextStyle(color: Colors.white)),
              )),
        ),
      );
    }

    if(castConnectionState == GoogleCastConnectState.connected) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                const GoogleTextWidget('Reproduciendo en Chromecast:', style: TextStyle(color: Colors.white)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    stream!.channel.card,
                    height: 150,
                    width: 150,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.tv, size: 80, color: Colors.white),
                  ),
                ),
              ],
            ),
        ),
      );
    }

    return AbsorbPointer(child: Player(videoController: _videoController!));
  }

  /// Chromecast functions
  void initPlatformState() {
    if (Platform.isAndroid) {
      const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
      GoogleCastOptions? options;
        options = GoogleCastOptionsAndroid(
          appId: appId,
        );
      GoogleCastContext.instance.setSharedInstanceWithOptions(options);
    }
  }

  Future<void> connectToChromecastDevice(GoogleCastDevice device) async {

    await GoogleCastSessionManager.instance.startSessionWithDevice(device);

    await GoogleCastSessionManager.instance.currentSessionStream.firstWhere((conn) => conn?.connectionState == GoogleCastConnectState.connected);

    await GoogleCastDiscoveryManager.instance.stopDiscovery();

    await launchChannelChromeCast(stream!);
  }

  Future<void> launchChannelChromeCast(StreamEntity stream) async {

    await _videoController?.pause();

    await GoogleCastRemoteMediaClient.instance.queueLoadItems(
      [
        GoogleCastQueueItem(
          mediaInformation: GoogleCastMediaInformationAndroid(
            contentId: stream.channel.number.toString(),
            streamType: CastMediaStreamType.live,
            contentUrl: Uri.parse(stream.link),
            contentType: 'application/x-mpegurl',
            metadata: GoogleCastMovieMediaMetadata(
              title: stream.channel.title,
              studio: 'Canal: ${stream.channel.number}',
              releaseDate: DateTime.now(),
              images: [
                GoogleCastImage(
                  url: Uri.parse(stream.channel.card),
                  height: 480,
                  width: 854,
                ),
              ],
            ),
          ),
        ),
      ],
      options: GoogleCastQueueLoadOptions(),
    );
  }

  void listenToChromecastEvents(){
    GoogleCastRemoteMediaClient.instance.mediaStatusStream.listen((event) {
      switch(event?.playerState) {
        case CastMediaPlayerState.loading:
        case CastMediaPlayerState.buffering:
          setState(() => playerStatus = PlayerStatus.buffering);
          break;
        case CastMediaPlayerState.playing:
          setState(() => playerStatus = PlayerStatus.playing);
          break;
        case CastMediaPlayerState.idle:
          if(event?.idleReason == GoogleCastMediaIdleReason.error && context.mounted) {
            setState(() => playerStatus = PlayerStatus.error);
          }
          break;
        default:
          break;
      }

    });

    GoogleCastSessionManager.instance.currentSessionStream.listen((event) {

      if(event?.connectionState == null) {
        return;
      }

      switch(event?.connectionState){
        case GoogleCastConnectState.connecting:
          setState(() => _step = PlayerSteps.chromecastLoading);
        default: setState(() => castConnectionState = event!.connectionState ?? GoogleCastConnectState.disconnected);
      }
    });
  }

  Widget content(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
              //Player
              if (_videoController != null)
                InkWell(
                    onTap: () {

                      if(_step == PlayerSteps.catchup) {
                        setState(() => _step = PlayerSteps.none);
                        return;
                      }

                      setState(() => _step = catchupPlaying ? PlayerSteps.catchupControls : PlayerSteps.controls);
                    },
                    child: casePlaying(context)
                ),

              //Controls
              if(_step == PlayerSteps.controls)
                Positioned.fill(
                    child: AnimatedOpacity(
                        opacity: _step == PlayerSteps.controls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Controls(
                          illumination: _illumination,
                          canUsePip: _canUsePip,
                          canUseCatchup: stream!.catchupEnabled,
                          onPipPressed: () async {
                            if(_canUsePip && Platform.isAndroid) {
                              await floating.enable(const ImmediatePiP());
                            }
                          },
                          volume: _volume,
                          channel: stream!.channel,
                          onPressed: () => setState(() => _step = PlayerSteps.none),
                          onLeftPressed: () => BaseButtonChannel.toLeft(ref),
                          onRightPressed: () => BaseButtonChannel.toRight(ref),
                          onCastPressed: ({required bool connected}){
                            //aqui el chromecast inicio la busqueda por eso debemos mostrar el selector
                            if(connected) {
                              setState(() {
                                _timerHideInfo?.cancel();
                                _step = PlayerSteps.chromecastSelector;
                              });
                              return;
                            }

                            launchChannel(stream!, forceDevice: true);
                            //aqui el chromecast se desconecto por eso debemos reanudar la reproduccion en el dispositivo
                            return;
                          },
                          onInfoPressed: () => setState(() => _step = PlayerSteps.epg),
                          onCatchUpPressed: () => setState(() => _step = PlayerSteps.catchup),
                          onChannelsPressed: () => setState(() => _step = PlayerSteps.channels),
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
                              // showInfo = true;
                            });
                          },
                        )
                    )
                ),

              //Epg
              if(_step == PlayerSteps.epg)
                EpgInfo(
                  onBackPressed: () => setState(() => _step = PlayerSteps.controls),
                  stream: stream!,
                ),

              if(_step == PlayerSteps.channels)
                AnimatedPositioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    width: _step == PlayerSteps.channels ? 350 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: const ChannelsMenu()
                ),

              if(_step == PlayerSteps.catchup)
                AnimatedPositioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    width: _step == PlayerSteps.catchup ? 300 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: Catchup(stream: stream!, onEpgSelected: (epg, status) {
                      if(status == CatchupStatus.notStarted) {
                        return;
                      }

                      if(status == CatchupStatus.playing) {
                        launchChannel(stream!);
                        return;
                      }

                      setCatchup(stream!, epg);
                    })
                ),

              if(_step == PlayerSteps.chromecastSelector)
                ChromecastSelector(
                  onClosed: (){
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

              if(_step == PlayerSteps.catchupControls && epgPlaying != null)
                CatchupControls(
                  epg: epgPlaying!,
                  stream: stream!,
                  onBackPressed: (){
                    launchChannel(stream!);
                  },
                  playerIcon: _videoController?.isPlaying() == false
                      ? Icons.play_circle_rounded
                      : Icons.pause_circle_rounded,
                  onPlayPressed: (){
                    setState(() {
                      if(_videoController?.isPlaying() == false) {
                        _videoController?.play();
                        return;
                      }
                      _videoController?.pause();
                    });
                  },
                  onScreenPressed: (){
                    setState(() {
                      _step = PlayerSteps.catchup;
                    });
                  },
                  sliderChild: Slider(
                    activeColor: AppTheme.secondaryColor(context),
                    value: epgPlayingTime,
                    max: epgPlaying!.run*60,
                    onChanged: (double value) {
                      setState(() {
                        epgPlayingTime = value;
                      });
                    },
                    onChangeEnd: (double value){
                      _videoController?.seekTo(Duration(seconds: value.toInt()));
                    },
                  ),
                  onEpgChange: (Epg epg, CatchupStatus status) {
                    if(status == CatchupStatus.playing) {
                      launchChannel(stream!);
                      return;
                    }
                    setCatchup(stream!, epg);
                  },
                )

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(channelPlayingProvider, (_, newState){
      newState.maybeWhen(orElse: () {}, success: (stream) {
        launchChannel(stream);
        setState(() {
          this.stream = stream;
        });
      });
    });

    if (_sensitiveData == null || stream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if(Platform.isAndroid) {
      return PiPSwitcher(
        childWhenDisabled: ChannelFade(
          channelKey: stream?.channel.number,
          child: content(context),
        ),
        childWhenEnabled: _videoController != null ? AspectRatio(
          aspectRatio: _videoController!.getAspectRatio() ?? 16/9,
          child: BetterPlayer(controller: _videoController!),
        ) : const SizedBox(),
      );
    }

    return ChannelFade(
      channelKey: stream?.channel.number,
      child: content(context),
    );

  }
}
