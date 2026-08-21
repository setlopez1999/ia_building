import 'package:tvapp/core/domain/entities/tools/diagnostico.dart';

abstract class DiagnosticoRepository {
  Future<List<Diagnostico>> getHistorial();
  Future<DiagnosticoSaveResult> saveDiagnostico(DiagnosticoRequest req);
}
