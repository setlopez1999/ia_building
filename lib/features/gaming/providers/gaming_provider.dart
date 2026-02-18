import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/game.dart';
import '../repositories/gaming_repository.dart';

part 'gaming_provider.g.dart';

@riverpod
GamingRepository gamingRepository(GamingRepositoryRef ref) {
  return GamingRepository();
}

@riverpod
Stream<List<Game>> games(GamesRef ref) {
  return ref.watch(gamingRepositoryProvider).watchGames();
}

@riverpod
Stream<Game?> gameDetail(GameDetailRef ref, String id) {
  return ref.watch(gamingRepositoryProvider).watchGame(id);
}
