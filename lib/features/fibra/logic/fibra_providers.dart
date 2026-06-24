import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/fibra_repository.dart';
import '../data/repositories/fibra_repository_impl.dart';
import '../../../shared/data/models/fibra.dart';
import '../../../core/providers/providers.dart';

final fibraRepositoryProvider = Provider<FibraRepository>((ref) {
  return FibraRepositoryImpl(ref.watch(apiClientProvider));
});

final fibraProvider = FutureProvider<Fibra>((ref) async {
  return ref.watch(fibraRepositoryProvider).getFibra();
});
