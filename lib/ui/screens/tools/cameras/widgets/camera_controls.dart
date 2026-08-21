import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CameraControls extends ConsumerWidget {
  const CameraControls(
      {super.key,
        required this.canUsePip,
        required this.onPipPressed,
        required this.onTvPressed,
        required this.onPressed,
        required this.onInfoPressed,
        required this.onListPressed,
        required this.onGridPressed,
        required this.onEventsPressed,
        required this.onAlertPressed,
        required this.onBrightnessChanged,
        required this.onVolumeChanged,
        required this.illumination,
        required this.volume,
        });

  final VoidCallback onPressed;
  final VoidCallback onInfoPressed;
  final VoidCallback onListPressed;
  final VoidCallback onGridPressed;
  final VoidCallback onEventsPressed;
  final VoidCallback onAlertPressed;
  final VoidCallback onPipPressed;
  final VoidCallback onTvPressed;
  final Function(double value) onBrightnessChanged;
  final Function(double value) onVolumeChanged;
  final double illumination;
  final double volume;
  final bool canUsePip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      animationDuration: Duration.zero,
      onPressed: onPressed,
      elevation: 0,
      color: Colors.black54,
      splashColor: Colors.black26,
      highlightColor: Colors.black26,
      child: SafeArea(
        right: false,
        left: false,
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(left: Platform.isAndroid ? 3 : 25, right: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_appBar(context), _middleBar(ref), _bottomBar(context)],
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
        splashColor: Colors.white,
        onPressed: () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      Row(
        children: [
          IconButton(
            splashColor: Colors.white,
            onPressed: onTvPressed,
            icon: const Icon(
              Icons.tv,
              color: Colors.white,
            ),
          ),
          if (Platform.isAndroid && canUsePip)
            IconButton(
              splashColor: Colors.white,
              onPressed: onPipPressed,
              icon: const Icon(
                Icons.picture_in_picture_alt,
                color: Colors.white,
              ),
            ),
        ],
      )
    ]);
  }

  Widget _middleBar(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _brightnessSlider(),
        Row(
          children: [
            IconButton(
              splashColor: Colors.white,
              onPressed: onInfoPressed,
              icon: const Icon(
                Icons.info_outline_rounded,
                size: 42,
                color: Colors.white,
              ),
            )
          ],
        ),
        _volumeSlider()
      ],
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: GoogleTextWidget('Menú de Cámaras', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: const Icon(
                    Icons.menu_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                    onPressed: onListPressed,
                    label: const GoogleTextWidget('Lista',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))
                ),
                TextButton.icon(
                  icon: const Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                    onPressed: onGridPressed,
                    label: const GoogleTextWidget('Mosaico',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))
                ),

              ],
            )
          ],
        ),

        InkWell(
          onTap: onAlertPressed,
          child: Row(
            spacing: 10,
            children: [
              Image.asset('assets/icons/detector.png', width: 32, height: 32, color: Colors.white),
              const GoogleTextWidget('Detección de\n movimientos',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white), textAlign: TextAlign.center)
            ],
          ),
        )
      ],
    );
  }

  Widget _brightnessSlider() {
    return Column(
      children: [
        const Icon(
          Icons.sunny,
          color: Colors.white,
          size: 24,
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: RotatedBox(
            quarterTurns: -1,
            child: Slider(
                value: illumination,
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                thumbColor: Colors.transparent,
                onChanged: onBrightnessChanged),
          ),
        )
      ],
    );
  }

  Widget _volumeSlider() {
    return Column(
      children: [
        Icon(
          volume >= 0.1
              ? Icons.volume_up
              : volume == 0.0
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
              value: volume,
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              thumbColor: Colors.transparent,
              onChanged: onVolumeChanged,
            ),
          ),
        ),
      ],
    );
  }
}
