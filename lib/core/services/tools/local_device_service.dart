import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:tvapp/core/domain/entities/tools/wifi_info.dart';
import 'package:tvapp/core/domain/entities/tools/dispositivo.dart';

class LocalDeviceService {
  final _networkInfo = NetworkInfo();

  Future<WifiInfo> getWifiInfo() async {
    try {
      final ssid = await _networkInfo.getWifiName();
      final bssid = await _networkInfo.getWifiBSSID();
      final ip = await _networkInfo.getWifiIP();
      final gateway = await _networkInfo.getWifiGatewayIP();
      final subnet = await _networkInfo.getWifiSubmask();

      int? signalDbm;
      int? frequencyMhz;

      try {
        final wireless = await Process.run('cat', ['/proc/net/wireless']);
        if (wireless.exitCode == 0) {
          final lines = wireless.stdout.toString().split('\n');
          for (final line in lines) {
            if (line.contains(':') && !line.startsWith('Inter')) {
              final parts = line.split(RegExp(r'\s+'));
              if (parts.length >= 4) {
                signalDbm = int.tryParse(parts[3].replaceAll('.', ''));
              }
            }
          }
        }
      } catch (_) {}

      try {
        final iwResult = await Process.run('iw', ['dev', 'wlan0', 'info']);
        if (iwResult.exitCode == 0) {
          final iwOut = iwResult.stdout.toString();
          final freqMatch =
              RegExp(r'channel\s+(\d+)\s+\((\d+)\s*MHz\)').firstMatch(iwOut);
          if (freqMatch != null) {
            frequencyMhz = int.tryParse(freqMatch.group(2)!);
          }
        }
      } catch (_) {}

      return WifiInfo(
        ssid: ssid != null ? ssid.replaceAll('"', '') : null,
        bssid: bssid,
        signalStrengthDbm: signalDbm,
        frequencyMhz: frequencyMhz,
        ipAddress: ip,
        gatewayAddress: gateway,
        subnetMask: subnet,
      );
    } catch (e) {
      return WifiInfo.empty();
    }
  }

  Future<List<Dispositivo>> scanLocalDevices() async {
    final devices = <Dispositivo>[];
    try {
      final result = await Process.run('cat', ['/proc/net/arp']);
      if (result.exitCode != 0) return _mockDevices();

      final lines = result.stdout.toString().split('\n');
      int id = 0;

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('IP')) continue;

        final parts = trimmed.split(RegExp(r'\s+'));
        if (parts.length < 6) continue;
        if (parts[2] != '0x2') continue;

        final ip = parts[0];
        final hwType = parts[1];
        final mac = parts[3].toUpperCase();

        if (hwType != '0x1') continue;

        id++;
        final vendorName = _guessDeviceName(mac);
        final deviceType = _guessDeviceType(mac, vendorName);

        String? hostname;
        try {
          final pingResult = await Process.run(
            'ping',
            ['-c', '1', '-W', '1', ip],
          );
          if (pingResult.exitCode == 0) {
            final pingOut = pingResult.stdout.toString();
            final hostnameRegex = RegExp(r'from\s+(\S+)\s+',
                caseSensitive: false);
            final match = hostnameRegex.firstMatch(pingOut);
            if (match != null) {
              final resolved = match.group(1)!.replaceAll('(', '').replaceAll(')', '');
              if (resolved != ip) hostname = resolved;
            }
          }
        } catch (_) {}

        devices.add(Dispositivo(
          id: 'local_$id',
          nombre: hostname ?? vendorName,
          mac: mac,
          ipLocal: ip,
          tipo: deviceType,
          conectado: true,
        ));
      }
    } catch (_) {
      return _mockDevices();
    }

    if (devices.isEmpty) return _mockDevices();
    return devices;
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    String model = 'Desconocido';
    String osVersion = 'Desconocido';

    try {
      final propsResult = await Process.run('getprop', []);
      if (propsResult.exitCode == 0) {
        final output = propsResult.stdout.toString();

        final modelMatch = RegExp(r'ro\.product\.model]:\s*\[(.+)\]')
            .firstMatch(output);
        if (modelMatch != null) model = modelMatch.group(1)!;

        final releaseMatch =
            RegExp(r'ro\.build\.version\.release]:\s*\[(.+)\]')
                .firstMatch(output);
        if (releaseMatch != null) {
          osVersion = 'Android ${releaseMatch.group(1)}';
        }
      }
    } catch (_) {}

    return {
      'model': model,
      'osVersion': osVersion,
    };
  }

  String _guessDeviceName(String mac) {
    final oui = mac.replaceAll(':', '').substring(0, 6).toUpperCase();
    const vendors = <String, String>{
      '000393': 'Apple',
      '001B63': 'Apple',
      '040CCE': 'Apple',
      '086698': 'Apple',
      'AC293A': 'Apple',
      'B03495': 'Apple',
      'C8B5B7': 'Apple',
      'D023DB': 'Apple',
      'F01898': 'Apple',
      'F81EDF': 'Apple',
      '0023D4': 'Samsung',
      '002637': 'Samsung',
      '047586': 'Samsung',
      '086266': 'Samsung',
      '147DDA': 'Samsung',
      '244BFE': 'Samsung',
      '3443A0': 'Samsung',
      '509BF4': 'Samsung',
      '5C4979': 'Samsung',
      '641CAE': 'Samsung',
      '708BCD': 'Samsung',
      '782C2E': 'Samsung',
      '7C2C4E': 'Samsung',
      '8416F9': 'Samsung',
      '8C0821': 'Samsung',
      '901B0E': 'Samsung',
      'A47758': 'Samsung',
      'C0A0BB': 'Samsung',
      'D03972': 'Samsung',
      'D4088F': 'Samsung',
      'E05A1F': 'Samsung',
      'F45C89': 'Samsung',
      'F85C7D': 'Xiaomi',
      '48022A': 'Xiaomi',
      '649EF3': 'Xiaomi',
      '68545A': 'Xiaomi',
      '8CDE52': 'Xiaomi',
      '9CFCE8': 'Xiaomi',
      'D46A6A': 'Xiaomi',
      'EC1482': 'Xiaomi',
      '081077': 'Huawei',
      '0C1DAF': 'Huawei',
      '102B67': 'Huawei',
      '1C5A6B': 'Huawei',
      '204C9E': 'Huawei',
      '246EC8': 'Huawei',
      '286ED4': 'Huawei',
      '2C59E5': 'Huawei',
      '306E5C': 'Huawei',
      '342912': 'Huawei',
      '3859F9': 'Huawei',
      '3C7D0D': 'Huawei',
      '446CD9': 'Huawei',
      '487ADA': 'Huawei',
      '4C17EB': 'Huawei',
      '509A7B': 'Huawei',
      '545200': 'Huawei',
      '5C514F': 'Huawei',
      '606BBD': 'Huawei',
      '64168C': 'Huawei',
      '688D5E': 'Huawei',
      '6C9B02': 'Huawei',
      '706D15': 'Huawei',
      '742F68': 'Huawei',
      '7836CC': 'Huawei',
      '7CDD90': 'Huawei',
      '805FE8': 'Huawei',
      '842B76': 'Huawei',
      '88722C': 'Huawei',
      '8C8DEA': 'Huawei',
      '94DF58': 'Huawei',
      '98B6E9': 'Huawei',
      'A0E201': 'Huawei',
      'A45E60': 'Huawei',
      'A8FB70': 'Huawei',
      'B07D47': 'Huawei',
      'B4247B': 'Huawei',
      'B8BC1B': 'Huawei',
      'C04A00': 'Huawei',
      'C49DED': 'Huawei',
      'C89CDC': 'Huawei',
      'D48A63': 'Huawei',
      'D8B370': 'Huawei',
      'DC0B1A': 'Huawei',
      'E0BE3D': 'Huawei',
      'E4F8EF': 'Huawei',
      'E83E89': 'Huawei',
      'EC656F': 'Huawei',
      'F49634': 'Huawei',
      'F84D89': 'Huawei',
      'FC6BF0': 'Huawei',
      '18B092': 'Google',
      '3C5A37': 'Google',
      '40BD32': 'Google',
      '44D9E8': 'Google',
      '5CC7D7': 'Google',
      '6466B3': 'Google',
      'F4F5D8': 'Google',
      '40B076': 'Amazon',
      '747548': 'Amazon',
      '789684': 'Amazon',
      '84D6D0': 'Amazon',
      '8C6D50': 'Amazon',
      '9C5181': 'Amazon',
      'AC63BE': 'Amazon',
      'B0E558': 'Amazon',
      'F0272B': 'Amazon',
      '14CF92': 'TP-Link',
      '18A6F7': 'TP-Link',
      '1C3BF3': 'TP-Link',
      '20E882': 'TP-Link',
      '2887BA': 'TP-Link',
      '2CB05A': 'TP-Link',
      '30B49E': 'TP-Link',
      '34725A': 'TP-Link',
      '383CF5': 'TP-Link',
      '401641': 'TP-Link',
      '44321B': 'TP-Link',
      '482254': 'TP-Link',
      '4CEDDE': 'TP-Link',
      '50C7BF': 'TP-Link',
      '5453ED': 'TP-Link',
      '54AF97': 'TP-Link',
      '6032B1': 'TP-Link',
      '646E69': 'TP-Link',
      '687251': 'TP-Link',
      '6C5AB0': 'TP-Link',
      '703ACB': 'TP-Link',
      '704F57': 'TP-Link',
      '74DA38': 'TP-Link',
      '780CB8': 'TP-Link',
      '7CD1C3': 'TP-Link',
      '84D81B': 'TP-Link',
      '88AE1D': 'TP-Link',
      '8C09F4': 'TP-Link',
      '940C6D': 'TP-Link',
      '988D46': 'TP-Link',
      '9CC7D1': 'TP-Link',
      'A071A4': 'TP-Link',
      'A42BB0': 'TP-Link',
      'A81512': 'TP-Link',
      'AC4AA0': 'TP-Link',
      'B07FB9': 'TP-Link',
      'B4A4E3': 'TP-Link',
      'B888E3': 'TP-Link',
      'C03F0E': 'TP-Link',
      'C46E6E': 'TP-Link',
      'C83A35': 'TP-Link',
      'CC32E5': 'TP-Link',
      'D03745': 'TP-Link',
      'D46E0E': 'TP-Link',
      'D824BD': 'TP-Link',
      'D80D17': 'TP-Link',
      'E0CC7A': 'TP-Link',
      'E46F13': 'TP-Link',
      'E848B8': 'TP-Link',
      'EC172F': 'TP-Link',
      'F02F74': 'TP-Link',
      'F4EC38': 'TP-Link',
      'F88B83': 'TP-Link',
      'FCF8AE': 'TP-Link',
      '001B21': 'Intel',
      '001F3C': 'Intel',
      '00216A': 'Intel',
      '002314': 'Intel',
      '0024D7': 'Intel',
      '0026C6': 'Intel',
      '340286': 'Intel',
      '3C77E6': 'Intel',
      '40169E': 'Intel',
      '484520': 'Intel',
      '4C5262': 'Intel',
      '5CFF35': 'Intel',
      '6C2995': 'Intel',
      '705A0F': 'Intel',
      '7845C4': 'Intel',
      '7CED8D': 'Intel',
      '843A4B': 'Intel',
      '88B1E1': 'Intel',
      '8C04BA': 'Intel',
      '8C705A': 'Intel',
      'A088B4': 'Intel',
      'A434D9': 'Intel',
      'B4AE2B': 'Intel',
      'B88AEC': 'Intel',
      'BCEE7B': 'Intel',
      'C0CB38': 'Intel',
      'C48508': 'Intel',
      'D05099': 'Intel',
      'D43D7E': 'Intel',
      'DCFE18': 'Intel',
      'E0D464': 'Intel',
      'E4A7A0': 'Intel',
      'E839DF': 'Intel',
      'EC086B': 'Intel',
      'F0BF97': 'Intel',
      'F46D04': 'Intel',
      'F832E4': 'Intel',
      'FCF5C4': 'Intel',
      '001018': 'Broadcom',
      'F8E4FB': 'Realtek',
      '00E04C': 'Realtek',
      '384B44': 'Realtek',
      '3CCE73': 'Realtek',
      '4CE2F8': 'Realtek',
      '503EAA': 'Realtek',
      '5404A6': 'Realtek',
      '586C6A': 'Realtek',
      '604C6D': 'Realtek',
      '64F6BB': 'Realtek',
      '68AB1E': 'Realtek',
      '74DAEA': 'Realtek',
      '784561': 'Realtek',
      '7C67A2': 'Realtek',
      '9457A5': 'Realtek',
      '949F6E': 'Realtek',
      'ACF1DF': 'Realtek',
      'B0487A': 'Realtek',
      'B4B024': 'Realtek',
      'C00D10': 'Realtek',
      'C85B76': 'Realtek',
      'D02788': 'Realtek',
      'D85D4C': 'Realtek',
      'E0DDA0': 'Realtek',
      'E45D51': 'Realtek',
      'E8DE27': 'Realtek',
      'F8B156': 'Realtek',
    };

    if (vendors.containsKey(oui)) {
      return '${vendors[oui]} - ${mac.substring(9)}';
    }
    return 'Dispositivo - ${mac.substring(9)}';
  }

  String _guessDeviceType(String mac, String vendorName) {
    final oui = mac.replaceAll(':', '').substring(0, 6).toUpperCase();
    const applePhones = <String>{
      '000393', '001B63', '040CCE', '086698',
      'AC293A', 'B03495', 'C8B5B7', 'D023DB',
      'F01898', 'F81EDF',
    };
    const samsungPhones = <String>{
      '0023D4', '002637', '047586', '086266',
      '147DDA', '244BFE', '3443A0', '509BF4',
      '5C4979', '641CAE', '708BCD', '782C2E',
      '7C2C4E', '8416F9', '8C0821', '901B0E',
      'A47758', 'C0A0BB', 'D03972', 'D4088F',
      'E05A1F', 'F45C89',
    };
    const xiaomiPhones = <String>{
      'F85C7D', '48022A', '649EF3', '68545A',
      '8CDE52', '9CFCE8', 'D46A6A', 'EC1482',
    };
    const routerVendors = <String>{
      '14CF92', '18A6F7', '1C3BF3', '20E882',
      '2887BA', '2CB05A', '30B49E', '34725A',
      '383CF5', '401641', '44321B', '482254',
      '4CEDDE', '50C7BF', '5453ED', '54AF97',
      '6032B1', '646E69', '687251', '6C5AB0',
      '703ACB', '704F57', '74DA38', '780CB8',
      '7CD1C3', '84D81B', '88AE1D', '8C09F4',
      '940C6D', '988D46', '9CC7D1', 'A071A4',
      'A42BB0', 'A81512', 'AC4AA0', 'B07FB9',
      'B4A4E3', 'B888E3', 'C03F0E', 'C46E6E',
      'C83A35', 'CC32E5', 'D03745', 'D46E0E',
      'D824BD', 'D80D17', 'E0CC7A', 'E46F13',
      'E848B8', 'EC172F', 'F02F74', 'F4EC38',
      'F88B83', 'FCF8AE',
    };
    const tvVendors = <String>{
      'F8E4FB', '00E04C', '384B44', '3CCE73',
      '4CE2F8', '503EAA', '5404A6', '586C6A',
      '604C6D', '64F6BB', '68AB1E', '74DAEA',
      '784561', '7C67A2', '9457A5', '949F6E',
      'ACF1DF', 'B0487A', 'B4B024', 'C00D10',
      'C85B76', 'D02788', 'D85D4C', 'E0DDA0',
      'E45D51', 'E8DE27', 'F8B156',
    };

    if (applePhones.contains(oui)) return 'smartphone';
    if (samsungPhones.contains(oui)) return 'smartphone';
    if (xiaomiPhones.contains(oui)) return 'smartphone';
    if (routerVendors.contains(oui)) return 'router';
    if (tvVendors.contains(oui)) return 'tv';

    final vendor = vendorName.toLowerCase();
    if (vendor.contains('intel')) return 'pc';
    if (vendor.contains('broadcom')) return 'pc';
    if (vendor.contains('google')) return 'tv';
    if (vendor.contains('amazon')) return 'tv';
    if (vendor.contains('huawei')) return 'smartphone';

    return 'smartphone';
  }

  List<Dispositivo> _mockDevices() {
    return [
      Dispositivo(
        id: 'gw',
        nombre: 'Router Principal',
        mac: 'FF:FF:FF:FF:FF:01',
        ipLocal: '192.168.1.1',
        tipo: 'router',
        conectado: true,
      ),
      Dispositivo(
        id: 'mock_1',
        nombre: 'Smartphone',
        mac: 'AA:BB:CC:DD:EE:01',
        ipLocal: '192.168.1.100',
        tipo: 'smartphone',
        conectado: true,
      ),
      Dispositivo(
        id: 'mock_2',
        nombre: 'PC',
        mac: 'AA:BB:CC:DD:EE:02',
        ipLocal: '192.168.1.101',
        tipo: 'pc',
        conectado: true,
      ),
    ];
  }
}

final localDeviceServiceProvider = Provider<LocalDeviceService>(
  (_) => LocalDeviceService(),
);
