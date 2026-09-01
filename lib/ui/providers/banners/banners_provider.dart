import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/repositories/banners_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/banners_demo_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/banners_http_repository.dart';

/// Única decisión sobre de dónde salen los banners. La UI consume la interfaz.
///
/// **No depende de `DEMO`.** El endpoint real ya funciona: el servidor manda
/// los banners del operador en la clave `slider` de la sesión. Atarlos al flag
/// los escondería, porque `DEMO=true` hace falta para otra cosa distinta —que
/// el hub muestre sus módulos mientras el backend no manda los flags `modulos`.
///
/// Si el servidor no responde, el carrusel simplemente no se dibuja; no
/// necesita respaldo. [BannersDemoRepository] queda disponible para trabajar
/// sin conexión, cambiando esta línea a mano.
final bannersRepositoryProvider =
    Provider<BannersRepository>((ref) => BannersHttpRepository());

class BannersNotifier extends Notifier<ContentState<List<String>>> {
  @override
  ContentState<List<String>> build() => const ContentState.initial();

  Future<void> load() async {
    state = const ContentState.loading();
    final result = await ref.read(bannersRepositoryProvider).getBanners();
    result.fold(
      (error) => state = ContentState.error(error),
      (urls) => state = ContentState.success(urls),
    );
  }
}

final bannersProvider =
    NotifierProvider<BannersNotifier, ContentState<List<String>>>(
  BannersNotifier.new,
);
