import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/entities/tools/wifi_info.dart';
import 'package:tvapp/core/domain/entities/tools/dispositivo.dart';

class LocalDeviceInfo {
  final String? name;
  final String? model;
  final String? ipAddress;

  const LocalDeviceInfo({this.name, this.model, this.ipAddress});
}

class LocalDeviceService {
  Future<WifiInfo> getWifiInfo() async {
    return WifiInfo.empty();
  }

  Future<LocalDeviceInfo> getDeviceInfo() async {
    return const LocalDeviceInfo();
  }

  Future<List<Dispositivo>> scanLocalDevices() async {
    return [];
  }
}

final localDeviceServiceProvider = Provider<LocalDeviceService>((ref) {
  return LocalDeviceService();
});
