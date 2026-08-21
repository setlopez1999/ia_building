import 'package:tvapp/core/domain/entities/tools/dispositivo.dart';

abstract class DispositivoRepository {
  Future<List<Dispositivo>> getDispositivos();
}
