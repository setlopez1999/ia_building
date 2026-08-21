import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/ui/providers/category/category_provider.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/providers/channel_playing/channel_playing_provider.dart';
import 'package:tvapp/ui/providers/channels_loaded/channels_loaded_provider.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/google_text_span.widget.dart';
import 'package:tvapp/ui/shared/widgets/row_button_channel.dart';

class ChannelsMenu extends ConsumerWidget {
  const ChannelsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final categoriesState = ref.watch(categoriesProvider);
    final categorySelectedState = ref.watch(categorySelectedProvider);
    final channelsState = ref.watch(channelsLoadedProvider);
    final channelPlayingState = ref.watch(channelPlayingProvider);
    final scrollController = ItemScrollController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: categoriesState.maybeWhen(
        success: (categories) {

          final index = (categories as List<Category>).indexWhere((cat) => cat.id == categorySelectedState!.id);

          return AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: index == 0 ? null : () {
                      BaseButtonChannel.selectCategory(categories[index - 1], ref);
                    },
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  Expanded(child: Text(categorySelectedState!.name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16),)),
                  IconButton(
                    onPressed: index == categories.length - 1  ? null : () {
                      BaseButtonChannel.selectCategory(categories[index + 1], ref);
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                  ),
                ],
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: googleStyle(context).merge(
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        orElse: () => AppBar(
          title: CircularProgressIndicator(
            color: AppTheme.secondaryColor(context),
          ),
        ),
      ),
      body: channelsState.maybeWhen(
        success: (channels) {
          return channelPlayingState.maybeWhen(
            success: (channelPlaying) {
              return ScrollablePositionedList.builder(
                itemScrollController: scrollController,
                physics: const ClampingScrollPhysics(),
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  final isPlaying = (channelPlaying as StreamEntity).channel.studio == (channel as Channel).studio;
                  if(isPlaying){
                    Future.microtask((){
                      scrollController.scrollTo(
                          index: index,
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.linear
                      );
                    });
                  }
                  return RowButtonChannel(
                      channel: channel,
                      silent: true,
                      focused: isPlaying);
                },
              );
            },
            orElse: SizedBox.new
          );
        },
        orElse: () => Center(
          child: CircularProgressIndicator(
            color: AppTheme.secondaryColor(context),
          ),
        ),
      ),
    );
  }
}
