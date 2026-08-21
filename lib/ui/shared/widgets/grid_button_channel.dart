import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/favorite_button.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class GridButtonChannel extends ConsumerStatefulWidget {
  const GridButtonChannel(
      {
        required this.channel,
        this.fromHome = false,
      });

  final Channel channel;
  final bool fromHome;

  _GridButtonChannelState createState() => _GridButtonChannelState();
}

class _GridButtonChannelState extends ConsumerState<GridButtonChannel> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                BaseButtonChannel.playChannel(channel: widget.channel, ref: ref, context: context, fromHome: widget.fromHome);
              },
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: 95,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.channel.card,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.tv, size: 40),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GoogleTextWidget(
                '${widget.channel.number} ${widget.channel.title}',
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                maxLines: 1,
              ),
            ),
            FavoriteButton(widget.channel, height: 40)
          ],
        )
      ],
    );
  }
}
