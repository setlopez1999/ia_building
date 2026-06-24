class WifiInfo {
  final String? ssid;
  final String? bssid;
  final int? signalStrengthDbm;
  final int? frequencyMhz;
  final String? ipAddress;
  final String? gatewayAddress;
  final String? subnetMask;

  String get band {
    if (frequencyMhz == null) return '--';
    return frequencyMhz! >= 5000 ? '5 GHz' : '2.4 GHz';
  }

  String get signalQuality {
    if (signalStrengthDbm == null) return '--';
    final rssi = signalStrengthDbm!;
    if (rssi >= -50) return 'Excelente';
    if (rssi >= -60) return 'Buena';
    if (rssi >= -70) return 'Regular';
    return 'Mala';
  }

  const WifiInfo({
    this.ssid,
    this.bssid,
    this.signalStrengthDbm,
    this.frequencyMhz,
    this.ipAddress,
    this.gatewayAddress,
    this.subnetMask,
  });

  factory WifiInfo.empty() => const WifiInfo();
}
