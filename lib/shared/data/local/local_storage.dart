import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static const _kToken = 'jwt_token';
  static const _kClienteId = 'cliente_id';
  static const _kAssetsVersion = 'assets_version';
  static const _kGooglePingTarget = 'google_ping_target';
  static const _kIspPingTarget = 'isp_ping_target';
  static const _kChatSessionId = 'chat_session_id';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _p {
    assert(_prefs != null, 'LocalStorage.init() no fue llamado');
    return _prefs!;
  }

  static String? getToken() => _p.getString(_kToken);
  static Future<void> setToken(String token) => _p.setString(_kToken, token);
  static Future<void> removeToken() => _p.remove(_kToken);

  static String? getClienteId() => _p.getString(_kClienteId);
  static Future<void> setClienteId(String id) => _p.setString(_kClienteId, id);
  static Future<void> removeClienteId() => _p.remove(_kClienteId);

  static String? getAssetsVersion() => _p.getString(_kAssetsVersion);
  static Future<void> setAssetsVersion(String v) => _p.setString(_kAssetsVersion, v);

  static String? getGooglePingTarget() => _p.getString(_kGooglePingTarget);
  static String? getIspPingTarget() => _p.getString(_kIspPingTarget);

  static Future<void> setNetworkTargets({
    required String googlePingTarget,
    required String ispPingTarget,
  }) async {
    await _p.setString(_kGooglePingTarget, googlePingTarget);
    await _p.setString(_kIspPingTarget, ispPingTarget);
  }

  static String? getChatSessionId() => _p.getString(_kChatSessionId);
  static Future<void> setChatSessionId(String id) => _p.setString(_kChatSessionId, id);
  static Future<void> removeChatSessionId() => _p.remove(_kChatSessionId);

  static Future<void> clearSession() async {
    await removeToken();
    await removeClienteId();
  }
}
