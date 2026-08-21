import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/screens/player/widgets/chromecast_button.dart';
import 'package:tvapp/ui/shared/widgets/favorite_button.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class Controls extends ConsumerWidget {
  const Controls(
      {super.key,
        required this.canUsePip,
        required this.onPipPressed,
      required this.onPressed,
      required this.onLeftPressed,
      required this.onRightPressed,
      required this.onCastPressed,
      required this.onInfoPressed,
      required this.onCatchUpPressed,
      required this.onChannelsPressed,
      required this.onBrightnessChanged,
      required this.onVolumeChanged,
      required this.illumination,
      required this.volume,
      required this.canUseCatchup,
      required this.channel});

  final VoidCallback onPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final void Function({required bool connected}) onCastPressed;
  final VoidCallback onInfoPressed;
  final VoidCallback onCatchUpPressed;
  final VoidCallback onChannelsPressed;
  final VoidCallback onPipPressed;
  final Function(double value) onBrightnessChanged;
  final Function(double value) onVolumeChanged;
  final double illumination;
  final double volume;
  final Channel channel;
  final bool canUsePip;
  final bool canUseCatchup;

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
            context.pop();
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
          if (Platform.isAndroid && canUsePip)
            IconButton(
              splashColor: Colors.white,
              onPressed: onPipPressed,
              icon: const Icon(
                Icons.picture_in_picture_alt,
                color: Colors.white,
              ),
            ),
          ChromecastButton(onPressed: onCastPressed)
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
              onPressed: onLeftPressed,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 32),
            IconButton(
              splashColor: Colors.white,
              onPressed: onInfoPressed,
              icon: const Icon(
                Icons.info_outline_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 32),
            IconButton(
              splashColor: Colors.white,
              onPressed: onRightPressed,
              icon: const Icon(
                Icons.arrow_forward_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
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
        TextButton.icon(
          onPressed: onChannelsPressed,
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 32,
          ),
          label: const GoogleTextWidget(
            'Lista de canales',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        FavoriteButton(channel, withLabel : true),
        if (Environment.catchupEnabled) TextButton.icon(
            onPressed: onCatchUpPressed,
            icon: Icon(
              Icons.replay,
              color: canUseCatchup ? Colors.white : Colors.grey,
              size: 28,
            ),
            label: GoogleTextWidget(
              'Catch up',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: canUseCatchup ? Colors.white : Colors.grey),
            ),
          ) else const SizedBox(width: 220, height: 28,)
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
