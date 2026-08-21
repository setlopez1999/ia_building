import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/i_gaming_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/gaming_api_repository_impl.dart';
import 'package:tvapp/core/domain/entities/tools/servidor_juego.dart';

final gamingApiRepositoryImplProvider = Provider<GamingApiRepositoryImpl>((ref) {
  final repo = GamingApiRepositoryImpl(ToolsApiClient());
  ref.onDispose(repo.dispose);
  return repo;
});

final gamingApiRepositoryProvider = Provider<IGamingRepository>((ref) {
  return ref.watch(gamingApiRepositoryImplProvider);
});

final servidoresJuegoProvider = FutureProvider<List<ServidorJuego>>((ref) async {
  final timer = Timer.periodic(const Duration(seconds: 10), (_) {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);
  return ref.watch(gamingApiRepositoryProvider).getServidores();
});

final servidoresJuegoStreamProvider = StreamProvider<List<ServidorJuego>>((ref) {
  return ref.watch(gamingApiRepositoryImplProvider).watchServidores();
});

