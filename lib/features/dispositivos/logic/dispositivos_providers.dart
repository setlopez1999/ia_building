import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/dispositivo_repository.dart';
import '../data/repositories/dispositivo_repository_impl.dart';
import '../../../shared/data/models/dispositivo.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/local_device_service.dart';

final dispositivoRepositoryProvider = Provider<DispositivoRepository>((ref) {
  return DispositivoRepositoryImpl(ref.watch(apiClientProvider));
});

final dispositivosProvider = FutureProvider<List<Dispositivo>>((ref) async {
  try {
    final localDevices = await ref.watch(localDeviceServiceProvider).scanLocalDevices();
    if (localDevices.isNotEmpty) return localDevices;
  } catch (_) {}
  return ref.watch(dispositivoRepositoryProvider).getDispositivos();
});
