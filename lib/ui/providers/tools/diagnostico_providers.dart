import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/diagnostico_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/diagnostico_repository_impl.dart';
import 'package:tvapp/core/domain/entities/tools/diagnostico.dart';

final diagnosticoRepositoryProvider = Provider<DiagnosticoRepository>((ref) {
  return DiagnosticoRepositoryImpl(ToolsApiClient());
});

final historialDiagnosticoProvider = FutureProvider<List<Diagnostico>>((ref) async {
  return ref.watch(diagnosticoRepositoryProvider).getHistorial();
});
