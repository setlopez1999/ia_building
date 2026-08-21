import 'package:flutter_test/flutter_test.dart';
import 'package:tvapp/core/domain/entities/tools/servidor_juego.dart';

void main() {
  group('ServidorJuego — valores por defecto', () {
    const sv = ServidorJuego(
      id: '1',
      juego: 'Valorant',
      servidor: 'LATAM South',
      ubicacion: 'Santiago',
      ip: '191.98.0.1',
    );

    test('pingMs por defecto es 0', () => expect(sv.pingMs, equals(0)));
    test('jitterMs por defecto es 0', () => expect(sv.jitterMs, equals(0)));
    test('perdidaPaquetesPct por defecto es 0.0',
        () => expect(sv.perdidaPaquetesPct, equals(0.0)));
    test('estado por defecto es SIN_CONEXIÓN',
        () => expect(sv.estado, equals('SIN_CONEXIÓN')));
    test('logo por defecto es string vacío',
        () => expect(sv.logo, equals('')));
  });

  group('ServidorJuego — igualdad Freezed', () {
    test('dos instancias con mismos valores son iguales', () {
      const a = ServidorJuego(
          id: '1', juego: 'CS2', servidor: 'SA', ubicacion: 'BUE', ip: '1.2.3.4');
      const b = ServidorJuego(
          id: '1', juego: 'CS2', servidor: 'SA', ubicacion: 'BUE', ip: '1.2.3.4');
      expect(a, equals(b));
    });

    test('instancias con ip distinta no son iguales', () {
      const a = ServidorJuego(
          id: '1', juego: 'CS2', servidor: 'SA', ubicacion: 'BUE', ip: '1.2.3.4');
      const b = ServidorJuego(
          id: '1', juego: 'CS2', servidor: 'SA', ubicacion: 'BUE', ip: '9.9.9.9');
      expect(a, isNot(equals(b)));
    });
  });

  group('ServidorJuego — copyWith', () {
    const base = ServidorJuego(
      id: '2',
      juego: 'Fortnite',
      servidor: 'NA',
      ubicacion: 'Miami',
      ip: '5.5.5.5',
    );

    test('copyWith actualiza pingMs y preserva el resto', () {
      final updated = base.copyWith(pingMs: 42);
      expect(updated.pingMs, equals(42));
      expect(updated.juego, equals('Fortnite'));
      expect(updated.ip, equals('5.5.5.5'));
    });

    test('copyWith actualiza estado', () {
      final updated = base.copyWith(estado: 'EXCELENTE');
      expect(updated.estado, equals('EXCELENTE'));
      expect(updated.id, equals('2'));
    });

    test('copyWith actualiza logo', () {
      final updated = base.copyWith(logo: 'abc123');
      expect(updated.logo, equals('abc123'));
    });
  });

  group('ServidorJuego — serialización JSON', () {
    test('fromJson parsea todos los campos correctamente', () {
      final json = {
        'id': '3',
        'juego': 'Apex Legends',
        'servidor': 'SA East',
        'ubicacion': 'São Paulo',
        'ip': '177.0.0.1',
        'logo': 'base64data==',
        'pingMs': 30,
        'jitterMs': 5,
        'perdidaPaquetesPct': 1.5,
        'estado': 'BUENO',
      };

      final sv = ServidorJuego.fromJson(json);

      expect(sv.id, equals('3'));
      expect(sv.juego, equals('Apex Legends'));
      expect(sv.ip, equals('177.0.0.1'));
      expect(sv.logo, equals('base64data=='));
      expect(sv.pingMs, equals(30));
      expect(sv.estado, equals('BUENO'));
    });

    test('fromJson usa defaults cuando faltan campos opcionales', () {
      final json = {
        'id': '4',
        'juego': 'LoL',
        'servidor': 'LAS',
        'ubicacion': 'Santiago',
        'ip': '200.0.0.1',
      };

      final sv = ServidorJuego.fromJson(json);

      expect(sv.logo, equals(''));
      expect(sv.pingMs, equals(0));
      expect(sv.estado, equals('SIN_CONEXIÓN'));
    });

    test('toJson y fromJson son idempotentes (round-trip)', () {
      const original = ServidorJuego(
        id: '5',
        juego: 'DOTA 2',
        servidor: 'SA',
        ubicacion: 'Lima',
        ip: '45.0.0.1',
        logo: 'imgdata',
        pingMs: 55,
        jitterMs: 3,
        perdidaPaquetesPct: 0.5,
        estado: 'BUENO',
      );

      final restored = ServidorJuego.fromJson(original.toJson());
      expect(restored, equals(original));
    });
  });
}
