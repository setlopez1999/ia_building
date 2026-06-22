import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../data/sources/local/local_storage.dart';

/// Estado de las acciones sobre la red WiFi del cliente.
class WifiActionState {
  final bool isLoading;
  final bool? success;
  final String? errorMsg;

  const WifiActionState({
    this.isLoading = false,
    this.success,
    this.errorMsg,
  });

  WifiActionState copyWith({
    bool? isLoading,
    bool? success,
    String? errorMsg,
  }) =>
      WifiActionState(
        isLoading: isLoading ?? this.isLoading,
        success: success,
        errorMsg: errorMsg,
      );
}

/// Notifier para acciones CUA sobre la red WiFi.
/// CUA-CH2: POST /v1/wifi/nombre    (WIFI-1)
/// CUA-CH3: POST /v1/wifi/password  (WIFI-2)
class WifiNotifier extends StateNotifier<WifiActionState> {
  final Ref _ref;

  WifiNotifier(this._ref) : super(const WifiActionState());

  /// Cambia el nombre (SSID) de la red WiFi.
  Future<void> cambiarNombre(String nuevoNombre) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final clienteId = LocalStorage.getClienteId() ?? '';
      await _ref
          .read(wifiRepositoryProvider)
          .cambiarNombre(clienteId, nuevoNombre);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        success: false,
        errorMsg: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Cambia la contraseña de la red WiFi.
  Future<void> cambiarPassword(String nuevaPassword) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final clienteId = LocalStorage.getClienteId() ?? '';
      await _ref
          .read(wifiRepositoryProvider)
          .cambiarPassword(clienteId, nuevaPassword);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        success: false,
        errorMsg: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void reset() => state = const WifiActionState();
}

final wifiNotifierProvider =
    StateNotifierProvider<WifiNotifier, WifiActionState>(
  (ref) => WifiNotifier(ref),
);
