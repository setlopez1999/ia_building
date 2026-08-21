import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/channels_searched/channels_searched_provider.dart';
import 'package:tvapp/ui/screens/login/login.screen.dart';
import 'package:tvapp/ui/shared/utils/list_type.enum.dart';
import 'package:tvapp/ui/providers/category/category_provider.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/providers/channels_loaded/channels_loaded_provider.dart';
import 'package:tvapp/ui/providers/favorites/favorites_provider.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/category_selector.dart';
import 'package:tvapp/ui/shared/widgets/channel_list_type_button.dart';
import 'package:tvapp/ui/shared/widgets/channels_list.dart';
import 'package:tvapp/ui/screens/guide/guide.screen.dart';
import 'package:tvapp/ui/screens/search/search.screen.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  static String name = 'channels';

  @override
  ConsumerState createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen> {
  ListType listType = ListType.list;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final categorySelected = ref.read(categorySelectedProvider);

      if (categorySelected == null) {
        ref.read(categorySelectedProvider.notifier).setDefault();
        ref.read(channelsLoadedProvider.notifier).get();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);
    final categorySelectedState = ref.watch(categorySelectedProvider);
    final channels = ref.watch(channelsLoadedProvider);

    BaseButtonChannel.working = false;

    return Scaffold(
        appBar: customAppBar(
          context,
          title: 'Canales',
          actions: [
            /// Comments
            IconButton(
              onPressed: () {
                context.pushNamed(GuideScreen.name);
              },
              icon: Image.asset(
                'assets/icons/guide.png',
                width: 24,
                height: 24,
              ),
            ),

            IconButton(
              onPressed: () {
                ref.read(channelsSearchedProvider.notifier).get();
                context.pushNamed(SearchScreen.name);
              },
              icon: Image.asset(
                'assets/icons/search.png',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              if (categorySelectedState != null)
                categoriesState.maybeWhen(
                    orElse: SizedBox.new,
                    success: (categories) => CategorySelector(
                        categories: categories,
                        categoryActive: categorySelectedState,
                        onTap: (category) {
                          ref
                              .read(categorySelectedProvider.notifier)
                              .selectCategory(category);
                        })),
              ChannelListTypeButton(
                  listType: listType,
                  onPressed: () {
                    setState(() {
                      listType = listType == ListType.list
                          ? ListType.grid
                          : ListType.list;
                    });
                  }),
              const SizedBox(height: 4),
              if (categorySelectedState != null)
                channels.maybeWhen(
                    orElse: SizedBox.new,
                    error: (error) {
                      if (error.statusCode == 3001) {
                        Future.microtask(() async {
                          await ref.read(authProvider.notifier).logout();
                        });
                      }
                      return const SizedBox();
                    },
                    success: (channels) {
                      return ChannelsList(
                        listType: listType,
                        channels: channels,
                      );
                    })
            ],
          ),
        ));
  }
}
