import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Única fuente del token de sesión de la app.
///
/// La app tiene **un solo sistema de autenticación**: `POST /api/inicio` contra
/// `BASE_HOST`. Es el login que lleva años en producción y del que dependen
/// todos los módulos.
///
/// Antes cada módulo se conseguía el token por su cuenta:
///   - IPTV lo tomaba del estado en memoria (`authProvider`).
///   - Mi cuenta y contactos pasaban por el repositorio de auth.
///   - Check Health **abría SharedPreferences y parseaba el JSON a mano**.
///
/// Esa tercera vía es la que hacía invisible el problema: al cambiar el
/// almacenamiento (por ejemplo al cifrarlo) IPTV seguía andando y Check Health
/// se rompía en silencio. Ahora todos piden el token acá.
///
/// ⚠️ Este es el único lugar del proyecto que puede leer la clave `'data'`.
/// Cuando se cifre la sesión, se cambia solo este archivo.
class SessionTokenSource {
  static final SessionTokenSource _instance = SessionTokenSource._internal();
  factory SessionTokenSource() => _instance;
  SessionTokenSource._internal();

  /// Clave donde el repositorio de auth guarda la sesión.
  static const String storageKey = 'data';

  /// Token vigente, o `null` si no hay sesión.
  Future<String?> token() async => _field('token');

  /// Email de la sesión, que varias APIs piden como identificador.
  Future<String?> email() async => _field('email');

  /// Identificador del usuario en el sistema IPTV.
  Future<String?> userId() async => _field('userID');

  Future<String?> _field(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(storageKey);
      if (raw == null || raw.isEmpty) return null;

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final value = map[key];
      if (value == null) return null;

      final text = value.toString().trim();
      return text.isEmpty ? null : text;
    } catch (_) {
      return null;
    }
  }

  Future<bool> get haySesion async => (await token()) != null;
}
