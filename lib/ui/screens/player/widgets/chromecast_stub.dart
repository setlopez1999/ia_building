library chromecast;

class GoogleCastConnectState {
  static const disconnected = GoogleCastConnectState._('disconnected');
  static const connected = GoogleCastConnectState._('connected');
  static const connecting = GoogleCastConnectState._('connecting');
  final String name;
  const GoogleCastConnectState._(this.name);
}

class GoogleCastDevice {
  final String deviceId;
  final String friendlyName;
  final String modelName;
  GoogleCastDevice({required this.deviceId, required this.friendlyName, this.modelName = ''});
}

class GoogleCastSession {
  GoogleCastConnectState? get connectionState => GoogleCastConnectState.disconnected;
}

class GoogleCastDiscoveryManager {
  static final GoogleCastDiscoveryManager instance = GoogleCastDiscoveryManager._();
  GoogleCastDiscoveryManager._();
  final devicesStream = Stream<List<GoogleCastDevice>>.empty();
  Future<void> startDiscovery() async {}
  Future<void> stopDiscovery() async {}
}

class GoogleCastRemoteMediaClient {
  static final GoogleCastRemoteMediaClient instance = GoogleCastRemoteMediaClient._();
  GoogleCastRemoteMediaClient._();
  final mediaStatusStream = Stream<CastMediaStatus?>.empty();
  Future<void> queueLoadItems(List<GoogleCastQueueItem> items, {GoogleCastQueueLoadOptions? options}) async {}
}

class GoogleCastSessionManager {
  static final GoogleCastSessionManager instance = GoogleCastSessionManager._();
  GoogleCastSessionManager._();
  GoogleCastConnectState get connectionState => GoogleCastConnectState.disconnected;
  final currentSessionStream = Stream<GoogleCastSession?>.empty();
  Future<void> endSessionAndStopCasting() async {}
  Future<void> startSessionWithDevice(GoogleCastDevice device) async {}
  GoogleCastRemoteMediaClient? get remoteMediaClient => GoogleCastRemoteMediaClient.instance;
}

class GoogleCastDiscoveryCriteria {
  static const kDefaultApplicationId = '4F8B7483';
}

class GoogleCastOptions {
  final String receiverApplicationId;
  GoogleCastOptions({required this.receiverApplicationId});
}

class GoogleCastContext {
  static GoogleCastContext? _inst;
  static GoogleCastContext get instance => _inst!;
  void setSharedInstanceWithOptions(GoogleCastOptions options) { _inst = GoogleCastContext._(); }
  GoogleCastContext._();
  GoogleCastContext({required GoogleCastOptions options}) { _inst = this; }
}

class CastMediaStreamType {
  static const Buffered = CastMediaStreamType._('Buffered');
  static const live = CastMediaStreamType._('Live');
  final String name;
  const CastMediaStreamType._(this.name);
}

class CastMediaPlayerState {
  static const loading = CastMediaPlayerState._('loading');
  static const buffering = CastMediaPlayerState._('buffering');
  static const playing = CastMediaPlayerState._('playing');
  static const idle = CastMediaPlayerState._('idle');
  final String name;
  const CastMediaPlayerState._(this.name);
}

class CastMediaStatus {
  CastMediaPlayerState? get playerState => CastMediaPlayerState.idle;
  GoogleCastMediaIdleReason? get idleReason => GoogleCastMediaIdleReason.None;
}

class GoogleCastMediaInformationAndroid {
  GoogleCastMediaInformationAndroid({contentId, streamType, Uri? contentUrl, contentType, metadata});
}

class GoogleCastMovieMediaMetadata {
  GoogleCastMovieMediaMetadata({String? title, List<GoogleCastImage>? images, String? subtitle, String? studio, dynamic releaseDate});
}

class GoogleCastImage {
  GoogleCastImage({Uri? url, int? height, int? width});
}

class GoogleCastQueueItem {
  GoogleCastQueueItem({mediaInformation, bool? autoplay, double? startTime, preloadTime, double? playDuration});
}

class GoogleCastQueueLoadOptions {
  GoogleCastQueueLoadOptions({List<GoogleCastQueueItem>? items, int? repeatMode, double? startIndex, double? playPosition, customData});
}

class GoogleCastMediaIdleReason {
  static const None = GoogleCastMediaIdleReason._('None');
  static const Cancelled = GoogleCastMediaIdleReason._('Cancelled');
  static const Interrupted = GoogleCastMediaIdleReason._('Interrupted');
  static const Finished = GoogleCastMediaIdleReason._('Finished');
  static const error = GoogleCastMediaIdleReason._('Error');
  final String name;
  const GoogleCastMediaIdleReason._(this.name);
}

class GoogleCastOptionsAndroid extends GoogleCastOptions {
  GoogleCastOptionsAndroid({String? appId, bool? enable11, launchOptions}) : super(receiverApplicationId: appId ?? '');
}
