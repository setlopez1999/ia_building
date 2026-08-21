import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/wifi_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/tools/wifi_repository_impl.dart';

part 'wifi_notifier.g.dart';

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

final wifiRepositoryProvider = Provider<WifiRepository>((ref) {
  return WifiRepositoryImpl(ToolsApiClient());
});

final wifiSsidProvider = FutureProvider<String?>((ref) {
  return ref.watch(wifiRepositoryProvider).getSsid();
});

@riverpod
class WifiNotifier extends _$WifiNotifier {
  @override
  WifiActionState build() => const WifiActionState();

  Future<void> cambiarNombre(String nuevoNombre) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      await ref.read(wifiRepositoryProvider).cambiarNombre(nuevoNombre);
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
      await ref.read(wifiRepositoryProvider).cambiarPassword(nuevaPassword);
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
