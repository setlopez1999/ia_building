package tv.oneplay.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {

    companion object {
        private const val PLAYER_EVENTS_CHANNEL = "tv.oneplay.app/playerEvents"
        private const val NATIVE_PLAYER_CONTROL_CHANNEL = "tv.oneplay.app/nativePlayerControl"
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("srt_view",
                NativeViewFactory())

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, PLAYER_EVENTS_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    eventSink = sink
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })

        // Control del player nativo (tiempo real) desde Flutter: silenciar al
        // reproducir un evento de movimiento para que no suene el audio en vivo.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NATIVE_PLAYER_CONTROL_CHANNEL)
            .setMethodCallHandler { call, result ->
                val view = NativeView.activeView
                when (call.method) {
                    "mute" -> {
                        view?.setVolume(0f)
                        result.success(null)
                    }
                    "unmute" -> {
                        view?.setVolume(1f)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
