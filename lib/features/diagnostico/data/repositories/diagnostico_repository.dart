import '../../../../shared/data/models/diagnostico.dart';

abstract class DiagnosticoRepository {
  Future<List<Diagnostico>> getHistorial();
  Future<DiagnosticoSaveResult> saveDiagnostico(DiagnosticoRequest req);
}
