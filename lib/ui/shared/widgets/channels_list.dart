import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/providers/favorites/favorites_provider.dart';
import 'package:tvapp/ui/shared/utils/list_type.enum.dart';
import 'package:tvapp/ui/shared/widgets/grid_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/row_button_channel.dart';

class ChannelsList extends ConsumerWidget {
  const ChannelsList({
    super.key,
    required this.listType,
    required this.channels
  });

  final ListType listType;
  final List<Channel> channels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final favorites = ref.watch(favoritesProvider);

    return favorites.when(
        initial: () {
          Future.microtask(() {
            ref.read(favoritesProvider.notifier).get();
          });
          return const SizedBox();
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: AppTheme.secondaryColor(context)),
        ),
        error: (err) => const SizedBox(),
        success: (favorites){
          if (listType == ListType.list) {
            return Expanded(
                child: ListView.builder(
                    itemCount: channels.length,
                    itemBuilder: (BuildContext context, int index) {
                      final channel = channels[index];
                      return RowButtonChannel(channel: channel, fromHome: true);
                    })
              );
          }

          return Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                children: channels
                    .map((channel) => GridButtonChannel(channel: channel, fromHome: true))
                    .toList()
            ),
          );
        }
    );


  }
}
