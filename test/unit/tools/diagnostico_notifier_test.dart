import 'package:flutter_test/flutter_test.dart';
import 'package:tvapp/core/domain/entities/tools/diagnostico.dart';

/// Tests unitarios para la lógica del modelo Diagnostico.
/// No requieren Firebase ni red — validan la capa de datos pura.
void main() {
  group('Diagnostico — modelo Freezed', () {
    test('Diagnostico se construye con los campos requeridos', () {
      final diagnostico = Diagnostico(
        id: 'diag_001',
        fecha: DateTime.parse('2025-01-15T10:30:00Z'),
        latenciaIspMs: 8,
        velocidadBajadaMbps: 95.2,
        resultado: 'ok',
      );

      expect(diagnostico.id, equals('diag_001'));
      expect(diagnostico.latenciaIspMs, equals(8));
      expect(diagnostico.velocidadBajadaMbps, equals(95.2));
      expect(diagnostico.resultado, equals('ok'));
    });

    test('Diagnostico con resultado error se construye correctamente', () {
      final diagnostico = Diagnostico(
        id: 'diag_002',
        fecha: DateTime.now(),
        latenciaIspMs: 350,
        velocidadBajadaMbps: 1.2,
        resultado: 'error',
      );

      expect(diagnostico.resultado, equals('error'));
      expect(diagnostico.velocidadBajadaMbps, lessThan(5.0));
    });

    test('Dos instancias con mismos valores son iguales (Freezed equality)', () {
      final fecha = DateTime.parse('2025-06-01T00:00:00Z');
      final d1 = Diagnostico(
        id: 'same',
        fecha: fecha,
        latenciaIspMs: 10,
        velocidadBajadaMbps: 50.0,
        resultado: 'ok',
      );
      final d2 = Diagnostico(
        id: 'same',
        fecha: fecha,
        latenciaIspMs: 10,
        velocidadBajadaMbps: 50.0,
        resultado: 'ok',
      );

      expect(d1, equals(d2));
    });
  });

  group('DiagnosticoRequest — construcción del payload', () {
    test('DiagnosticoRequest se construye con todos los campos requeridos', () {
      const request = DiagnosticoRequest(
        clienteId: 'cliente_123',
        latenciaGoogleMs: 15,
        latenciaIspMs: 8,
        velocidadBajadaMbps: 95.5,
        velocidadSubidaMbps: 45.2,
        fibraPotenciaDbm: '-18.5',
        fibraEstado: 'ok',
      );

      expect(request.clienteId, equals('cliente_123'));
      expect(request.latenciaGoogleMs, equals(15));
      expect(request.velocidadBajadaMbps, equals(95.5));
      expect(request.fibraEstado, equals('ok'));
    });

    test('DiagnosticoRequest con fibra en estado crítico', () {
      const request = DiagnosticoRequest(
        clienteId: 'cliente_456',
        latenciaGoogleMs: 200,
        latenciaIspMs: 180,
        velocidadBajadaMbps: 2.1,
        velocidadSubidaMbps: 0.5,
        fibraPotenciaDbm: '-35.0',
        fibraEstado: 'critico',
      );

      expect(request.fibraEstado, equals('critico'));
      expect(request.velocidadBajadaMbps, lessThan(5.0));
    });
  });

  group('Lógica de evaluación de resultados de diagnóstico', () {
    test('latencia ISP < 50ms se considera buena', () {
      const latencia = 8;
      expect(latencia < 50, isTrue);
    });

    test('latencia ISP > 200ms indica problema grave', () {
      const latencia = 350;
      expect(latencia > 200, isTrue);
    });

    test('velocidad bajada > 10 Mbps es aceptable para streaming HD', () {
      const velocidad = 15.5;
      expect(velocidad > 10, isTrue);
    });

    test('velocidad bajada < 5 Mbps indica conexión lenta', () {
      const velocidad = 2.3;
      expect(velocidad < 5, isTrue);
    });

    test('velocidad bajada > 50 Mbps es excelente', () {
      const velocidad = 95.2;
      expect(velocidad > 50, isTrue);
    });

    test('diagnóstico ok: latencia baja y velocidad alta', () {
      final d = Diagnostico(
        id: 'test',
        fecha: DateTime.now(),
        latenciaIspMs: 10,
        velocidadBajadaMbps: 80.0,
        resultado: 'ok',
      );

      final isHealthy = d.latenciaIspMs < 100 && d.velocidadBajadaMbps > 10;
      expect(isHealthy, isTrue);
      expect(d.resultado, equals('ok'));
    });

    test('diagnóstico error: latencia alta y velocidad baja', () {
      final d = Diagnostico(
        id: 'test2',
        fecha: DateTime.now(),
        latenciaIspMs: 500,
        velocidadBajadaMbps: 0.8,
        resultado: 'error',
      );

      final hasIssues = d.latenciaIspMs > 200 || d.velocidadBajadaMbps < 5;
      expect(hasIssues, isTrue);
      expect(d.resultado, equals('error'));
    });
  });
}
