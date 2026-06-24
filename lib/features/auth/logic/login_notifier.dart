import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_notifier.dart';

class LoginFormState {
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMsg;

  const LoginFormState({
    this.obscurePassword = true,
    this.isLoading = false,
    this.errorMsg,
  });

  LoginFormState copyWith({
    bool? obscurePassword,
    bool? isLoading,
    String? errorMsg,
  }) =>
      LoginFormState(
        obscurePassword: obscurePassword ?? this.obscurePassword,
        isLoading: isLoading ?? this.isLoading,
        errorMsg: errorMsg,
      );
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Ref _ref;

  LoginFormNotifier(this._ref) : super(const LoginFormState());

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo requerido';
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo requerido';
    return null;
  }

  Future<void> submit(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    await _ref.read(authNotifierProvider.notifier).login(email, password);
    final authState = _ref.read(authNotifierProvider);
    state = state.copyWith(
      isLoading: false,
      errorMsg: authState.isAuthenticated ? null : authState.errorMsg,
    );
  }
}

final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(ref),
);
