import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/providers/favorites/favorites_provider.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/favorite_button.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class RowButtonChannel extends ConsumerStatefulWidget {
  const RowButtonChannel({
    super.key,
    required this.channel,
    this.silent = false,
    this.focused = false,
    this.fromHome = false,
  });

  final Channel channel;
  final bool silent;
  final bool focused;
  final bool fromHome;

  @override
  _RowButtonChannelState createState() => _RowButtonChannelState();
}

class _RowButtonChannelState extends ConsumerState<RowButtonChannel> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        BaseButtonChannel.playChannel(channel: widget.channel, ref: ref, context: context, silent: widget.silent, fromHome: widget.fromHome);
      },
      child: Row(
        children: [
          Container(
            color: widget.focused ? Colors.white24 : Colors.transparent,
            width: 64,
            height: 70,
            child: Center(
              child: GoogleTextWidget(
                widget.channel.number.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: widget.focused ? Colors.white24 : Colors.transparent,
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.channel.card,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          final uri = Uri.parse(widget.channel.card);
                          final urlFormatted = Uri(
                            scheme: uri.scheme,
                            host: uri.host,
                            path: uri.path,
                          ).toString();

                          return Image.network(
                            urlFormatted,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Si falla, muestra un ícono de error
                              return const Icon(Icons.error);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GoogleTextWidget(
                      widget.channel.title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  FavoriteButton(widget.channel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
