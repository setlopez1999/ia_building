import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/repositories/banners_repository.dart';
import 'package:tvapp/core/infraestructure/datasource/session_token_source.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Banners reales del operador.
///
/// Vienen en la clave `slider` de la sesión (`{BASE_HOST}/{token}/inicio.json`),
/// alojados en el propio servidor del ISP:
///
/// ```json
/// "slider": [
///   { "imagen": "https://oneplay.iptvperu.tv/img/sliders/imagen_1651682820.jpg" }
/// ]
/// ```
///
/// El `LoginDto` no declara este campo, por eso se descartaba al parsear la
/// sesión y el hub terminaba mostrando fotos de stock escritas a mano.
class BannersHttpRepository implements BannersRepository {
  static const String _key = 'slider';
  static const String _imageField = 'imagen';

  @override
  Future<Either<AppException, List<String>>> getBanners() async {
    final token = await SessionTokenSource().token();

    if (token == null) {
      return Left(AppException(
        identifier: 'Banners',
        message: 'No hay sesión activa.',
        statusCode: 6200,
        detail: 'SessionTokenSource no devolvió token.',
      ));
    }

    final url = '${Environment.baseHost}/$token/inicio.json';

    try {
      final res = await Dio().get(
        url,
        options: Options(validateStatus: (status) => true),
      );

      final data = res.data;

      if (res.statusCode != 200 || data is! Map) {
        return Left(AppException(
          identifier: 'Banners',
          message: 'No se pudieron cargar los banners.',
          statusCode: res.statusCode ?? 0,
          detail: 'GET $url\nHTTP ${res.statusCode}\n${jsonEncode(data)}',
        ));
      }

      if (data.containsKey('error')) {
        return Left(AppException(
          identifier: 'Banners',
          message: 'La sesión no es válida para este servidor.',
          statusCode: 6201,
          detail: 'GET $url\n${jsonEncode(data)}',
        ));
      }

      final slider = data[_key];
      if (slider is! List) return const Right([]);

      final urls = slider
          .whereType<Map>()
          .map((e) => (e[_imageField] ?? '').toString().trim())
          .where((u) => u.isNotEmpty)
          .toList();

      return Right(urls);
    } catch (e) {
      return Left(AppException(
        identifier: 'Banners',
        message: 'No se pudo conectar con el servidor.',
        statusCode: 6202,
        detail: 'GET $url\n$e',
      ));
    }
  }
}
