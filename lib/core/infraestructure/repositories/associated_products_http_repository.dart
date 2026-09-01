import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/products/associated_product.dart';
import 'package:tvapp/core/domain/repositories/associated_products_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Implementación contra la API del mismo servidor de la app (`BASE_HOST`).
///
/// ⚠️ El endpoint todavía no existe. Mientras no responda, esta clase informa
/// que el servicio no está disponible en lugar de inventar productos
/// (Regla 4 de `docs/REGLAS.md`).
///
/// Cuando el backend lo entregue: ajustar [_path] si el nombre difiere, y
/// `AssociatedProduct.fromJson` si cambia el contrato. Nada más.
class AssociatedProductsHttpRepository implements AssociatedProductsRepository {
  /// Ruta provisional dentro del mismo host de la app.
  static const String _path = '/api/productos-asociados';

  @override
  Future<Either<AppException, List<AssociatedProduct>>> getProducts() async {
    final url = '${Environment.baseHost}$_path';

    try {
      final dio = Dio();
      final res = await dio.get(
        url,
        options: Options(validateStatus: (status) => true),
      );

      final data = res.data;

      // 404 o redirección: el endpoint todavía no está publicado.
      if (res.statusCode == 404 || (res.statusCode ?? 0) >= 300) {
        return Left(AppException(
          identifier: 'Productos',
          message: 'El listado de productos todavía no está disponible.',
          statusCode: res.statusCode ?? 0,
          detail: 'GET $url\nHTTP ${res.statusCode}\n'
              'El endpoint de productos asociados aún no existe.',
        ));
      }

      if (res.statusCode != 200) {
        return Left(AppException(
          identifier: 'Productos',
          message: 'No se pudieron cargar tus productos. Intenta nuevamente.',
          statusCode: res.statusCode ?? 0,
          detail: 'GET $url\nHTTP ${res.statusCode}\n${jsonEncode(data)}',
        ));
      }

      final lista = data is List
          ? data
          : (data is Map && data['data'] is List)
              ? data['data'] as List
              : null;

      if (lista == null) {
        return Left(AppException(
          identifier: 'Productos',
          message: 'El servidor respondió de forma inesperada.',
          statusCode: 6002,
          detail: 'GET $url\n${jsonEncode(data)}',
        ));
      }

      return Right(lista
          .whereType<Map>()
          .map((e) =>
              AssociatedProduct.fromJson(Map<String, dynamic>.from(e)))
          .toList());
    } catch (e) {
      return Left(AppException(
        identifier: 'Productos',
        message: 'No se pudo conectar con el servidor. Verifica tu conexión.',
        statusCode: 6003,
        detail: 'GET $url\n$e',
      ));
    }
  }
}
