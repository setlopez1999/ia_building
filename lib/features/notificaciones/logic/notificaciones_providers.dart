import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/notificacion_repository.dart';
import '../data/repositories/notificacion_repository_impl.dart';
import '../../../shared/data/models/notificacion.dart';
import '../../../core/providers/providers.dart';

final notificacionRepositoryProvider = Provider<NotificacionRepository>((ref) {
  return NotificacionRepositoryImpl(ref.read(apiClientProvider));
});

final notificacionesProvider = FutureProvider<List<Notificacion>>((ref) async {
  return ref.read(notificacionRepositoryProvider).getNotificaciones();
});

final notificacionesNoLeidasProvider = Provider<int>((ref) {
  return ref.watch(notificacionesProvider).maybeWhen(
        data: (list) => list.where((n) => !n.leido).length,
        orElse: () => 0,
      );
});
