import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../data/models/app_config.dart';

/// Estado de autenticación de la sesión.
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMsg;
  final AuthResult? authResult;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMsg,
    this.authResult,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMsg,
    AuthResult? authResult,
  }) =>
      AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        isLoading: isLoading ?? this.isLoading,
        errorMsg: errorMsg,
        authResult: authResult ?? this.authResult,
      );
}

/// Notifier que gestiona el flujo de autenticación.
/// POST /v1/auth/login  (AUTH-1)
///
/// Flujo:
///   Usuario ingresa email/rut + contraseña
///   → POST /v1/auth/login
///   → Éxito: guarda token JWT + cliente_id en SharedPreferences
///   → Token se adjunta automáticamente en header: Authorization: Bearer <token>
///   → Navega a HomeScreen
///   → Error: muestra mensaje
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState());

  Future<void> login(String usuario, String password) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final result =
          await _ref.read(authRepositoryProvider).login(usuario, password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        authResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMsg: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AuthState();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);
