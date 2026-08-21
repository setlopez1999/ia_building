import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/fibra_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/fibra_repository_impl.dart';
import 'package:tvapp/core/domain/entities/tools/fibra.dart';

final fibraRepositoryProvider = Provider<FibraRepository>((ref) {
  return FibraRepositoryImpl(ToolsApiClient());
});

final fibraProvider = FutureProvider<Fibra>((ref) async {
  return ref.watch(fibraRepositoryProvider).getFibra();
});
