/// Datos que necesita el teléfono para registrarse en una central.
///
/// Es la pieza que permite cambiar de central sin tocar la app: hoy los
/// valores salen del `.env` contra el Asterisk de pruebas; mañana los va a
/// entregar el backend, ya apuntando al VICIdial del cliente y con una
/// extensión por usuario.
class CallCredentials {
  const CallCredentials({
    required this.wsUrl,
    required this.host,
    required this.usuario,
    required this.clave,
    required this.destino,
    this.displayName = 'App',
  });

  /// WebSocket de la central, p. ej. `ws://192.168.0.53:8088/ws`.
  final String wsUrl;

  /// Dominio SIP, normalmente el host de la central.
  final String host;

  /// Extensión propia del teléfono.
  final String usuario;

  final String clave;

  /// A quién se llama al tocar el botón (una extensión o una cola).
  final String destino;

  final String displayName;

  /// URI SIP propia.
  String get uri => 'sip:$usuario@$host';

  /// URI SIP del destino.
  String get uriDestino => 'sip:$destino@$host';

  bool get esValida =>
      wsUrl.isNotEmpty &&
      host.isNotEmpty &&
      usuario.isNotEmpty &&
      destino.isNotEmpty;
}
