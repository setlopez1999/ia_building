import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/repositories/banners_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Banners de muestra, para revisar el maquetado del hub.
///
/// ⚠️ Se usan **solo** con `DEMO=true` en el `.env`. Son fotos de stock de
/// Unsplash: estaban escritas a mano dentro de la pantalla del hub y se veían
/// como si fueran contenido del operador. Ahora quedan acotadas al modo
/// demostración y desaparecen al apagar el flag.
class BannersDemoRepository implements BannersRepository {
  static const List<String> _stock = [
    'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop',
  ];

  @override
  Future<Either<AppException, List<String>>> getBanners() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const Right(_stock);
  }
}
