import '../../models/diagnostico.dart';

/// Contrato abstracto para diagnósticos de red.
/// GET  /v1/diagnosticos  (DIAG-2)
/// POST /v1/diagnosticos  (DIAG-1)
abstract class DiagnosticoRepository {
  /// Devuelve el historial de diagnósticos del cliente.
  Future<List<Diagnostico>> getHistorial();

  /// Persiste el resultado de un diagnóstico en el backend.
  Future<DiagnosticoSaveResult> saveDiagnostico(DiagnosticoRequest req);
}
