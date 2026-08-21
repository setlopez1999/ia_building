import 'package:flutter/services.dart';

/// Controla el reproductor nativo del tiempo real (ExoPlayer en `srt_view`).
/// Se usa para silenciar el audio en vivo mientras se reproduce un evento de
/// movimiento, y restaurarlo al volver.
class NativePlayerControlService {
  static const MethodChannel _channel = MethodChannel('tv.oneplay.app/nativePlayerControl');

  static Future<void> mute() async {
    try {
      await _channel.invokeMethod('mute');
    } catch (_) {}
  }

  static Future<void> unmute() async {
    try {
      await _channel.invokeMethod('unmute');
    } catch (_) {}
  }
}
