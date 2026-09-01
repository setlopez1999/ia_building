import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Banners promocionales del hub.
///
/// El operador los sube desde su dashboard y el servidor los manda en la clave
/// `slider` de la sesión. La UI depende solo de esta interfaz.
abstract class BannersRepository {
  Future<Either<AppException, List<String>>> getBanners();
}
