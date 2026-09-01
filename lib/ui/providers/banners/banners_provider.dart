import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/repositories/banners_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/banners_demo_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/banners_http_repository.dart';

/// Única decisión sobre de dónde salen los banners. La UI consume la interfaz.
final bannersRepositoryProvider = Provider<BannersRepository>((ref) {
  return Environment.demoMode
      ? BannersDemoRepository()
      : BannersHttpRepository();
});

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
