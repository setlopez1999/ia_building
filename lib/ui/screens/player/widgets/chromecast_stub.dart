library;

class GoogleCastConnectState {
  const GoogleCastConnectState._(this.name);
  static const disconnected = GoogleCastConnectState._('disconnected');
  static const connected = GoogleCastConnectState._('connected');
  static const connecting = GoogleCastConnectState._('connecting');
  final String name;
}

class GoogleCastDevice {
  GoogleCastDevice({required this.deviceId, required this.friendlyName, this.modelName = ''});
  final String deviceId;
  final String friendlyName;
  final String modelName;
}

class GoogleCastSession {
  GoogleCastConnectState? get connectionState => GoogleCastConnectState.disconnected;
}

class GoogleCastDiscoveryManager {
  GoogleCastDiscoveryManager._();
  static final GoogleCastDiscoveryManager instance = GoogleCastDiscoveryManager._();
  final devicesStream = Stream<List<GoogleCastDevice>>.empty();
  Future<void> startDiscovery() async {}
  Future<void> stopDiscovery() async {}
}

class GoogleCastRemoteMediaClient {
  GoogleCastRemoteMediaClient._();
  static final GoogleCastRemoteMediaClient instance = GoogleCastRemoteMediaClient._();
  final mediaStatusStream = Stream<CastMediaStatus?>.empty();
  Future<void> queueLoadItems(List<GoogleCastQueueItem> items, {GoogleCastQueueLoadOptions? options}) async {}
}

class GoogleCastSessionManager {
  GoogleCastSessionManager._();
  static final GoogleCastSessionManager instance = GoogleCastSessionManager._();
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
  GoogleCastOptions({required this.receiverApplicationId});
  final String receiverApplicationId;
}

class GoogleCastContext {
  GoogleCastContext() { _inst = this; }
  GoogleCastContext._();
  static GoogleCastContext? _inst;
  static GoogleCastContext get instance => _inst!;
  void setSharedInstanceWithOptions(GoogleCastOptions options) { _inst = GoogleCastContext._(); }
}

class CastMediaStreamType {
  const CastMediaStreamType._(this.name);
  static const Buffered = CastMediaStreamType._('Buffered');
  static const live = CastMediaStreamType._('Live');
  final String name;
}

class CastMediaPlayerState {
  const CastMediaPlayerState._(this.name);
  static const loading = CastMediaPlayerState._('loading');
  static const buffering = CastMediaPlayerState._('buffering');
  static const playing = CastMediaPlayerState._('playing');
  static const idle = CastMediaPlayerState._('idle');
  final String name;
}

class CastMediaStatus {
  CastMediaPlayerState? get playerState => CastMediaPlayerState.idle;
  GoogleCastMediaIdleReason? get idleReason => GoogleCastMediaIdleReason.None;
}

class GoogleCastMediaInformationAndroid {
  GoogleCastMediaInformationAndroid();
}

class GoogleCastMovieMediaMetadata {
  GoogleCastMovieMediaMetadata();
}

class GoogleCastImage {
  GoogleCastImage();
}

class GoogleCastQueueItem {
  GoogleCastQueueItem();
}

class GoogleCastQueueLoadOptions {
  GoogleCastQueueLoadOptions();
}

class GoogleCastMediaIdleReason {
  const GoogleCastMediaIdleReason._(this.name);
  static const None = GoogleCastMediaIdleReason._('None');
  static const Cancelled = GoogleCastMediaIdleReason._('Cancelled');
  static const Interrupted = GoogleCastMediaIdleReason._('Interrupted');
  static const Finished = GoogleCastMediaIdleReason._('Finished');
  static const error = GoogleCastMediaIdleReason._('Error');
  final String name;
}

class GoogleCastOptionsAndroid extends GoogleCastOptions {
  GoogleCastOptionsAndroid({String? appId}) : super(receiverApplicationId: appId ?? '');
}
