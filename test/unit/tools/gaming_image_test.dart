import 'package:flutter_test/flutter_test.dart';
import 'package:tvapp/ui/shared/widgets/juego_logo_widget.dart';

// 1x1 pixel PNG en base64 puro (sin prefijo)
const _kPng1x1 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

void main() {
  group('decodeGameImage — función pura de decodificación', () {
    test('string vacío retorna null', () {
      expect(decodeGameImage(''), isNull);
    });

    test('base64 puro válido retorna Uint8List no vacío', () {
      final bytes = decodeGameImage(_kPng1x1);
      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
    });

    test('prefijo data:image/png;base64, es ignorado correctamente', () {
      final withPrefix = 'data:image/png;base64,$_kPng1x1';
      final bytes = decodeGameImage(withPrefix);
      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
    });

    test('prefijo data:image/jpeg;base64, también se descarta', () {
      final withPrefix = 'data:image/jpeg;base64,$_kPng1x1';
      final bytes = decodeGameImage(withPrefix);
      expect(bytes, isNotNull);
    });

    test('espacios y saltos de línea embebidos son eliminados', () {
      // Simula base64 con newlines (como lo envían algunos backends)
      final dirty = _kPng1x1.replaceAll('', '\n').trim();
      final bytes = decodeGameImage(dirty);
      expect(bytes, isNotNull);
    });

    test('base64 sin padding (sin =) es reparado y decodificado', () {
      final withoutPadding = _kPng1x1.replaceAll('=', '');
      final bytes = decodeGameImage(withoutPadding);
      expect(bytes, isNotNull);
    });

    test('prefijo + sin padding: ambos casos combinados funcionan', () {
      final combined =
          'data:image/png;base64,${_kPng1x1.replaceAll('=', '')}';
      final bytes = decodeGameImage(combined);
      expect(bytes, isNotNull);
    });

    test('base64 inválido retorna null sin lanzar excepción', () {
      expect(decodeGameImage('esto-no-es-base64-!!!###'), isNull);
    });

    test('bytes resultantes son iguales independientemente del prefijo', () {
      final pure = decodeGameImage(_kPng1x1);
      final withPrefix = decodeGameImage('data:image/png;base64,$_kPng1x1');
      expect(pure, equals(withPrefix));
    });
  });
}
