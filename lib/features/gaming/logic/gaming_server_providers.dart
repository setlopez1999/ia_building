import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/i_gaming_repository.dart';
import '../data/repositories/gaming_api_repository_impl.dart';
import '../../../shared/data/models/servidor_juego.dart';
import '../../../core/providers/providers.dart';

final gamingApiRepositoryImplProvider = Provider<GamingApiRepositoryImpl>((ref) {
  final repo = GamingApiRepositoryImpl(ref.read(apiClientProvider));
  ref.onDispose(repo.dispose);
  return repo;
});

final gamingApiRepositoryProvider = Provider<IGamingRepository>((ref) {
  return ref.read(gamingApiRepositoryImplProvider);
});

final servidoresJuegoProvider = FutureProvider<List<ServidorJuego>>((ref) async {
  return ref.read(gamingApiRepositoryProvider).getServidores();
});

final servidoresJuegoStreamProvider = StreamProvider<List<ServidorJuego>>((ref) {
  return ref.read(gamingApiRepositoryImplProvider).watchServidores();
});
