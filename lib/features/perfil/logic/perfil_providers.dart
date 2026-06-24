import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/perfil_repository.dart';
import '../data/repositories/perfil_repository_impl.dart';
import '../../../shared/data/models/user.dart';
import '../../../core/providers/providers.dart';

final perfilRepositoryProvider = Provider<PerfilRepository>((ref) {
  return PerfilRepositoryImpl(ref.watch(apiClientProvider));
});

final perfilProvider = FutureProvider<User>((ref) async {
  return ref.watch(perfilRepositoryProvider).getProfile();
});
