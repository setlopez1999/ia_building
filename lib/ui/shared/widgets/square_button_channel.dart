import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class SquareButtonChannel extends ConsumerWidget {
  const SquareButtonChannel({
    super.key,
    required this.channel,
    this.radius = 0,
    this.width = 100,
    this.height = 100,
    this.fontSize = 9,
    this.separatorHeight = 0,
  });

  final double radius;
  final double separatorHeight;
  final double width;
  final double height;
  final double fontSize;
  final dynamic channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: NetworkImage(channel.card),
            width: width,
            height: height,
            fit: BoxFit.cover,
            child: InkWell(
              onTap: () {
                BaseButtonChannel.playChannel(channel: channel, ref: ref, context: context);
              },
            ),
          ),
        ),
      ),
      SizedBox(height: separatorHeight),
      GoogleTextWidget(
        (channel.title as String).length > 7 ? '${(channel.title as String).substring(0, 7)}...' : channel.title,
        style: TextStyle(
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}
