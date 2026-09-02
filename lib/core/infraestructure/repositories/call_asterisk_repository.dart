import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/repositories/call_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Pide la llamada a la API de telefonía.
///
/// La app **no habla con la central directamente**: eso obligaría a llevar las
/// credenciales de Asterisk dentro del APK, y cualquiera que lo descomprima
/// podría originar llamadas. La API intermedia decide a quién se llama.
///
/// El host sale del `.env` (`CALL_API_HOST`), porque cambia según desde dónde
/// se pruebe: `10.0.2.2` es la máquina anfitriona vista desde el emulador,
/// mientras que un teléfono real necesita la IP del PC en la red local.
class CallAsteriskRepository implements CallRepository {
  @override
  Future<Either<AppException, void>> requestCall() async {
    final url =
        'http://${Environment.callApiHost}:${Environment.callApiPort}/call';

    try {
      final res = await Dio().post(
        url,
        options: Options(
          validateStatus: (status) => true,
          sendTimeout: const Duration(seconds: 12),
          receiveTimeout: const Duration(seconds: 12),
        ),
      );

      final data = res.data;

      if (res.statusCode == 200 && data is Map && data['ok'] == true) {
        return const Right(null);
      }

      final mensajeServidor =
          (data is Map ? data['mensaje'] : null)?.toString().trim();

      return Left(AppException(
        identifier: 'Llamada',
        message: mensajeServidor?.isNotEmpty == true
            ? mensajeServidor!
            : 'No se pudo solicitar la llamada. Intenta nuevamente.',
        statusCode: res.statusCode ?? 0,
        detail: 'POST $url\nHTTP ${res.statusCode}\n${jsonEncode(data)}',
      ));
    } catch (e) {
      return Left(AppException(
        identifier: 'Llamada',
        message: 'No se pudo conectar con el servicio de asistencia. '
            'Verifica tu conexión.',
        statusCode: 7002,
        detail: 'POST $url\n$e',
      ));
    }
  }
}
