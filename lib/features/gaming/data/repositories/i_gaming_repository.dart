import '../../../../shared/data/models/servidor_juego.dart';

abstract class IGamingRepository {
  Future<List<ServidorJuego>> getServidores();
}
