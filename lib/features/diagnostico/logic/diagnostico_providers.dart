import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/diagnostico_repository.dart';
import '../data/repositories/diagnostico_repository_impl.dart';
import '../../../shared/data/models/diagnostico.dart';
import '../../../core/providers/providers.dart';

final diagnosticoRepositoryProvider = Provider<DiagnosticoRepository>((ref) {
  return DiagnosticoRepositoryImpl(ref.watch(apiClientProvider));
});

final historialDiagnosticoProvider = FutureProvider<List<Diagnostico>>((ref) async {
  return ref.watch(diagnosticoRepositoryProvider).getHistorial();
});
