class ConnectivityStates {
  ConnectivityStates({required this.isConnected, this.isDialogClosedManually = false});
  final bool isConnected;
  final bool isDialogClosedManually;

  ConnectivityStates copyWith({bool? isConnected, bool? isDialogClosedManually}) {
    return ConnectivityStates(
      isConnected: isConnected ?? this.isConnected,
      isDialogClosedManually: isDialogClosedManually ?? this.isDialogClosedManually,
    );
  }
}