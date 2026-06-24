import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/auth_result.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../../../core/router/router_provider.dart';
import '../../../shared/data/remote/api_client.dart';
import '../../../core/constants/app_constants.dart';

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

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState());

  Future<void> login(String usuario, String password) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final result = await _ref.read(authRepositoryProvider).login(usuario, password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        authResult: result,
      );
      _ref.read(goRouterProvider).go('/');
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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ApiClient(baseUrl: AppConstants.baseUrl));
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);
