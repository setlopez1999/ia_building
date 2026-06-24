import '../../../../shared/data/models/dispositivo.dart';

abstract class DispositivoRepository {
  Future<List<Dispositivo>> getDispositivos();
}
