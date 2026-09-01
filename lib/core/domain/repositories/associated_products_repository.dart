import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/products/associated_product.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Fuente de "Otros productos asociados".
///
/// La UI depende solo de esta interfaz. El día que exista el endpoint, se
/// implementa acá y no se toca ni la lista ni el detalle.
abstract class AssociatedProductsRepository {
  Future<Either<AppException, List<AssociatedProduct>>> getProducts();
}
