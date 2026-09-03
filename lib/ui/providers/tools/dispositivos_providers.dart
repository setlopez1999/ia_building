import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/entities/tools/dispositivo.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/dispositivo_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/dispositivo_repository_impl.dart';

final dispositivoRepositoryProvider = Provider<DispositivoRepository>((ref) {
  return DispositivoRepositoryImpl(ToolsApiClient());
});

final dispositivosProvider = FutureProvider<List<Dispositivo>>((ref) async {
  return ref.watch(dispositivoRepositoryProvider).getDispositivos();
});
