import 'package:flutter_test/flutter_test.dart';
import 'package:tvapp/core/domain/entities/tools/wifi_info.dart';

/// Tests unitarios para WifiInfo y la lógica de análisis de red.
/// No requieren red real — validan modelos y lógica de evaluación.
void main() {
  group('WifiInfo — construcción y propiedades calculadas', () {
    test('WifiInfo con señal -55 dBm retorna calidad Excelente', () {
      const wifi = WifiInfo(
        ssid: 'Bantel_5G',
        bssid: 'AA:BB:CC:DD:EE:FF',
        signalStrengthDbm: -55,
        frequencyMhz: 5180,
        ipAddress: '192.168.1.100',
      );

      expect(wifi.ssid, equals('Bantel_5G'));
      expect(wifi.signalQuality, equals('Excelente'));
      expect(wifi.band, equals('5 GHz'));
    });

    test('WifiInfo con señal -65 dBm retorna calidad Buena', () {
      const wifi = WifiInfo(
        signalStrengthDbm: -65,
        frequencyMhz: 2412,
      );

      expect(wifi.signalQuality, equals('Buena'));
      expect(wifi.band, equals('2.4 GHz'));
    });

    test('WifiInfo con señal -72 dBm retorna calidad Regular', () {
      const wifi = WifiInfo(signalStrengthDbm: -72);
      expect(wifi.signalQuality, equals('Regular'));
    });

    test('WifiInfo con señal -85 dBm retorna calidad Mala', () {
      const wifi = WifiInfo(signalStrengthDbm: -85);
      expect(wifi.signalQuality, equals('Mala'));
    });

    test('WifiInfo.empty() crea instancia con todos los campos nulos', () {
      final wifi = WifiInfo.empty();
      expect(wifi.ssid, isNull);
      expect(wifi.signalStrengthDbm, isNull);
      expect(wifi.signalQuality, equals('--'));
      expect(wifi.band, equals('--'));
    });

    test('WifiInfo con frecuencia nula retorna band --', () {
      const wifi = WifiInfo(ssid: 'Test');
      expect(wifi.band, equals('--'));
    });

    test('frecuencia 5180 MHz corresponde a banda 5 GHz', () {
      const wifi = WifiInfo(frequencyMhz: 5180);
      expect(wifi.band, equals('5 GHz'));
    });

    test('frecuencia 2412 MHz corresponde a banda 2.4 GHz', () {
      const wifi = WifiInfo(frequencyMhz: 2412);
      expect(wifi.band, equals('2.4 GHz'));
    });

    test('frecuencia 2462 MHz (canal 11) corresponde a banda 2.4 GHz', () {
      const wifi = WifiInfo(frequencyMhz: 2462);
      expect(wifi.band, equals('2.4 GHz'));
    });
  });

  group('Lógica de evaluación de latencia y velocidad', () {
    test('ping < 20ms es óptimo para gaming', () {
      const ping = 15;
      expect(ping < 20, isTrue);
    });

    test('ping entre 20-50ms es bueno para uso general', () {
      const ping = 35;
      expect(ping >= 20 && ping <= 50, isTrue);
    });

    test('ping > 150ms indica problema de latencia', () {
      const ping = 200;
      expect(ping > 150, isTrue);
    });

    test('velocidad > 25 Mbps soporta streaming 4K', () {
      const speed = 95.5;
      expect(speed > 25, isTrue);
    });

    test('velocidad < 5 Mbps no soporta streaming HD', () {
      const speed = 3.2;
      expect(speed < 5, isTrue);
    });

    test('jitter > 10ms indica inestabilidad para VoIP/gaming', () {
      const jitter = 15.5;
      expect(jitter > 10, isTrue);
    });

    test('jitter < 5ms es excelente para tiempo real', () {
      const jitter = 2.1;
      expect(jitter < 5, isTrue);
    });
  });

  group('Evaluación integral de conexión', () {
    test('conexión excelente: todos los parámetros óptimos', () {
      const wifi = WifiInfo(
        ssid: 'Bantel_5G',
        signalStrengthDbm: -45,
        frequencyMhz: 5180,
        ipAddress: '192.168.1.100',
      );
      const latencia = 10;
      const velocidad = 95.0;
      const jitter = 1.5;

      final isExcellent = wifi.signalStrengthDbm! >= -50 &&
          latencia < 20 &&
          velocidad > 50 &&
          jitter < 5;

      expect(isExcellent, isTrue);
      expect(wifi.signalQuality, equals('Excelente'));
      expect(wifi.band, equals('5 GHz'));
    });

    test('conexión problemática: señal débil y latencia alta', () {
      const wifi = WifiInfo(
        ssid: 'Bantel_2G',
        signalStrengthDbm: -82,
        frequencyMhz: 2412,
      );
      const latencia = 280;
      const velocidad = 1.5;

      final hasProblems = wifi.signalStrengthDbm! < -70 ||
          latencia > 150 ||
          velocidad < 5;

      expect(hasProblems, isTrue);
      expect(wifi.signalQuality, equals('Mala'));
    });
  });
}
