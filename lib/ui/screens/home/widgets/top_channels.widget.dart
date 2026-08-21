import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/ui/shared/widgets/square_button_channel.dart';
import 'package:tvapp/ui/providers/top_channels/top_channels_provider.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class TopChannels extends ConsumerWidget {
  const TopChannels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final channels = ref.watch(topChannelsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GoogleTextWidget('Los 5 canales más vistos',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: Environment.h2FSize,
                fontWeight: FontWeight.bold,
              )),
        ),
        channels.maybeWhen(
          initial: () {
            Future.microtask(() => ref.read(topChannelsProvider.notifier).get());
            return const CircularProgressIndicator();
          },
          success: (channels) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: channels
                    .take(5)
                    .map<Widget>(
                      (channel) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SquareButtonChannel(
                          radius: 8,
                          width: 73,
                          height: 74,
                          fontSize: 12,
                          separatorHeight: 4,
                          channel: channel,
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          orElse: () => const SizedBox(),
        ),
      ],
    );
  }
}
