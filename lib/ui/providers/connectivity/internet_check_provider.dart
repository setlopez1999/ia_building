import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/system/connectivity_state.dart';

part 'internet_check_provider.g.dart'; // Riverpod annotation generation

@riverpod
class InternetCheck extends _$InternetCheck {
  @override
  Future<ConnectivityStates> build() async {
    await startMonitoring();
    return ConnectivityStates(isConnected: true);
    // return ConnectivityStates(isConnected: await checkFirstConnectivity());
  }

  Future<void> startMonitoring() async {
    final connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      final typeOfConnectivity = result.first;
      final isConnected = typeOfConnectivity != ConnectivityResult.none;
      // print('isConnected $isConnected');
      state = AsyncData(state.value!.copyWith(isConnected: isConnected));
    });
  }

  Future<bool> checkFirstConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final typeOfConnectivity = connectivityResult.first;
    final isConnected = typeOfConnectivity != ConnectivityResult.none;
    return isConnected;
  }


  Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final typeOfConnectivity = connectivityResult.first;
    final isConnected = typeOfConnectivity != ConnectivityResult.none;

    // print('isConnected $isConnected');
    state = AsyncData(ConnectivityStates(isConnected: isConnected));

    return isConnected;
  }

  void closeDialogManually() {
    state = AsyncData(state.value!.copyWith(isDialogClosedManually: true));
  }
}