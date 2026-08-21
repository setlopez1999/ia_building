import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/shared/utils/list_type.enum.dart';
import 'package:tvapp/ui/providers/category/category_provider.dart';
import 'package:tvapp/ui/providers/favorites/favorites_provider.dart';
import 'package:tvapp/ui/shared/widgets/category_selector.dart';
import 'package:tvapp/ui/shared/widgets/channel_list_type_button.dart';
import 'package:tvapp/ui/shared/widgets/channels_list.dart';

class FavoriteBody extends ConsumerStatefulWidget {
  const FavoriteBody({super.key});

  @override
  ConsumerState createState() => _FavoriteBodyWidgetState();
}

class _FavoriteBodyWidgetState extends ConsumerState<FavoriteBody> {
  /// Variables
  Category? categorySelectedState;
  ListType listType = ListType.list;

  /// Controllers
  final channelsCategoriesItemScrollController = ItemScrollController();
  final channelsChannelsItemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);
    final favoritesState = ref.watch(favoritesProvider);

    return favoritesState.maybeWhen(
        orElse: SizedBox.new,
        initial: () {
          Future.microtask(() {
            ref.read(favoritesProvider.notifier).get();
          });
          return const SizedBox();
        },
        success: (favorites) {
          final date = DateTime.now().toString();
          return Center(
            key: Key(date),
            child: categoriesState.maybeWhen(
                orElse: SizedBox.new,
                success: (categories) {

                  final favoriteCategoriesIds = favorites
                      .map((e) => e.category_id.toString())
                      .toSet();
                  final uniqueCategories = (categories as List<Category>)
                      .where((element) =>
                      favoriteCategoriesIds.contains(element.id))
                      .toList();


                  if (categorySelectedState == null) {
                    Future.microtask(() {
                      setState(() {
                        categorySelectedState = uniqueCategories.first;
                      });
                    });
                    return const SizedBox();
                  }

                  final channels = (favorites as List<Channel>).where((f) => f.category_id.toString() == categorySelectedState!.id)
                      .toList();

                  if (channels.isEmpty) {
                    Future.microtask(() {
                      setState(() {
                        categorySelectedState = uniqueCategories.first;
                      });
                    });
                    return const SizedBox();
                  }

                  return Column(
                    children: [
                      CategorySelector(
                          categories: uniqueCategories,
                          categoryActive: categorySelectedState!,
                          onTap: (category) {
                            setState(() {
                              categorySelectedState = category;
                            });
                          }),
                      ChannelListTypeButton(
                          listType: listType,
                          onPressed: () {
                            setState(() {
                              listType = listType == ListType.list
                                  ? ListType.grid
                                  : ListType.list;
                            });
                          }),
                      if (categorySelectedState != null)
                        ChannelsList(
                            listType: listType,
                            channels: channels,)
                    ],
                  );
                }),
          );
        });
  }
}
