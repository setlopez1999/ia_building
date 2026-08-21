class WifiInfo {
  final String? ssid;
  final String? bssid;
  final int? signalStrengthDbm;
  final int? frequencyMhz;
  final String? ipAddress;
  final String? gatewayAddress;
  final String? subnetMask;

  /// Banda ya resuelta por el backend (ej. "5GHz") — tiene prioridad sobre frequencyMhz.
  final String? bandOverride;

  /// Calidad de señal ya resuelta por el backend (ej. "Buena") — tiene prioridad sobre signalStrengthDbm.
  final String? signalQualityOverride;

  String get band {
    if (bandOverride != null) return bandOverride!;
    if (frequencyMhz == null) return '--';
    return frequencyMhz! >= 5000 ? '5 GHz' : '2.4 GHz';
  }

  String get signalQuality {
    if (signalQualityOverride != null) return signalQualityOverride!;
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
    this.bandOverride,
    this.signalQualityOverride,
  });

  factory WifiInfo.empty() => const WifiInfo();
}
