import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/wifi_repository.dart';
import '../data/repositories/wifi_repository_impl.dart';
import '../../../shared/data/local/local_storage.dart';
import '../../../core/providers/providers.dart';

class WifiActionState {
  final bool isLoading;
  final bool? success;
  final String? errorMsg;

  const WifiActionState({this.isLoading = false, this.success, this.errorMsg});

  WifiActionState copyWith({bool? isLoading, bool? success, String? errorMsg}) =>
      WifiActionState(
        isLoading: isLoading ?? this.isLoading,
        success: success,
        errorMsg: errorMsg,
      );
}

class WifiNotifier extends StateNotifier<WifiActionState> {
  final Ref _ref;

  WifiNotifier(this._ref) : super(const WifiActionState());

  Future<void> cambiarNombre(String nuevoNombre) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final clienteId = LocalStorage.getClienteId() ?? '';
      await _ref.read(wifiRepositoryProvider).cambiarNombre(clienteId, nuevoNombre);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        success: false,
        errorMsg: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> cambiarPassword(String nuevaPassword) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final clienteId = LocalStorage.getClienteId() ?? '';
      await _ref.read(wifiRepositoryProvider).cambiarPassword(clienteId, nuevaPassword);
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

final wifiRepositoryProvider = Provider<WifiRepository>((ref) {
  return WifiRepositoryImpl(ref.read(apiClientProvider));
});

final wifiNotifierProvider = StateNotifierProvider<WifiNotifier, WifiActionState>(
  (ref) => WifiNotifier(ref),
);
