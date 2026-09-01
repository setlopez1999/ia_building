class AppException implements Exception {
  AppException({
    required this.message,
    required this.statusCode,
    required this.identifier,
    this.detail,
  });

  /// Mensaje entendible para el usuario. Se muestra siempre.
  final String message;
  final int statusCode;
  final String identifier;

  /// Respuesta cruda del servidor o de la excepción.
  /// Regla 1.b: solo se muestra en pantalla con `APP_DEBUG_MODE=true`.
  final String? detail;

  @override
  String toString() {
    return 'statusCode=$statusCode\nmessage=$message\nidentifier=$identifier';
  }
}
