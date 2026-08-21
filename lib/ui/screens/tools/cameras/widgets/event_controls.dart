import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

class CameraEventControls extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback? onRewind;
  final VoidCallback? onForward;

  const CameraEventControls({
    super.key,
    required this.onBack,
    this.onRewind,
    this.onForward,
  });

  @override
  State<CameraEventControls> createState() => _CameraEventControlsState();
}

class _CameraEventControlsState extends State<CameraEventControls> {
  double _brightness = 1.0;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _initBrightness();
    _initVolume();
  }

  Future<void> _initBrightness() async {
    try {
      final b = await ScreenBrightness().current;
      if (mounted) setState(() => _brightness = b);
    } catch (_) {}
  }

  void _initVolume() {
    try {
      VolumeController.instance.addListener((volume) {
        if (mounted) setState(() => _volume = volume);
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: widget.onBack,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sunny, color: Colors.white, size: 24),
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      value: _brightness,
                      min: 0,
                      max: 1,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.transparent,
                      onChanged: (v) {
                        setState(() => _brightness = v);
                        ScreenBrightness().setScreenBrightness(v);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _volume >= 0.1
                      ? Icons.volume_up
                      : _volume == 0.0
                      ? Icons.volume_off_rounded
                      : Icons.volume_down,
                  color: Colors.white,
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      value: _volume,
                      min: 0,
                      max: 1,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.transparent,
                      onChanged: (v) {
                        setState(() => _volume = v);
                        VolumeController.instance.setVolume(v);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                onPressed: widget.onRewind,
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                onPressed: widget.onForward,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
