import 'package:tvapp/core/domain/entities/tools/wifi_info.dart';

abstract class WifiRepository {
  Future<void> cambiarNombre(String nuevoNombre);
  Future<void> cambiarPassword(String nuevaPassword);
  Future<String?> getSsid();

  /// Lee /v1/wifi/ssid completo: ssid, signal_dbm, band, signal_quality.
  Future<WifiInfo> getWifiStatus();
}
