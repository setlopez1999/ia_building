package tv.oneplay.app

import android.view.View
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import androidx.media3.ui.PlayerView
import io.flutter.plugin.platform.PlatformView

internal class NativeView(
    context: android.content.Context,
    id: Int,
    creationParams: Map<*, *>?
) : PlatformView {

    private val playerView: PlayerView = PlayerView(context).apply {
        useController = false
    }

    private val player: ExoPlayer = ExoPlayer.Builder(context).build()

    override fun getView(): View {
        return playerView
    }

    override fun dispose() {
        if (activeView == this) activeView = null
        player.stop()
        player.release()
    }

    init {
        playerView.player = player

        player.addListener(object : Player.Listener {
            override fun onPlaybackStateChanged(playbackState: Int) {
                val state = when (playbackState) {
                    Player.STATE_IDLE -> "idle"
                    Player.STATE_BUFFERING -> "buffering"
                    Player.STATE_READY -> "ready"
                    Player.STATE_ENDED -> "ended"
                    else -> "unknown"
                }
                MainActivity.eventSink?.success(mapOf("event" to "state", "value" to state))
            }

            override fun onPlayerError(error: PlaybackException) {
                val errMsg = error.message ?: "Unknown error"
                val causeMsg = error.cause?.message ?: ""
                MainActivity.eventSink?.success(
                    mapOf("event" to "error", "value" to "$errMsg | $causeMsg")
                )
            }
        })

        val url = creationParams?.get("url") as? String
        val muted = (creationParams?.get("muted") as? Boolean) ?: false
        if (muted) {
            player.volume = 0f
        }
        if (url != null) {
            setMediaItem(url)
        }

        activeView = this
    }

    fun setVolume(volume: Float) {
        player.volume = volume
    }

    fun setPlayWhenReady(value: Boolean) {
        player.playWhenReady = value
    }

    companion object {
        @Volatile var activeView: NativeView? = null
    }

    fun setMediaItem(url: String) {
        if (url.startsWith("srt://")) {
            val mediaSource = ProgressiveMediaSource.Factory(
                SrtDataSourceFactory(), TsOnlyExtractorFactory()
            ).createMediaSource(MediaItem.fromUri(url))
            player.setMediaSource(mediaSource)
        } else {
            player.setMediaItem(MediaItem.fromUri(url))
        }
        player.prepare()
        player.playWhenReady = true
    }
}
