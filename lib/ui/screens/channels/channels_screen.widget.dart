import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/ui/providers/category/category_provider.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/providers/channels_loaded/channels_loaded_provider.dart';
import 'package:tvapp/ui/providers/channels_searched/channels_searched_provider.dart';
import 'package:tvapp/ui/screens/guide/guide.screen.dart';
import 'package:tvapp/ui/screens/search/search.screen.dart';
import 'package:tvapp/ui/shared/utils/list_type.enum.dart';
import 'package:tvapp/ui/shared/widgets/api_state.widget.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/category_selector.dart';
import 'package:tvapp/ui/shared/widgets/channel_list_type_button.dart';
import 'package:tvapp/ui/shared/widgets/channels_list.dart';

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

    Future.microtask(_load);
  }

  /// Carga categorias y canales por su cuenta, sin depender de que el home
  /// las haya pedido antes.
  Future<void> _load() async {
    final needsCategories = ref.read(categoriesProvider).maybeWhen(
          success: (categories) => categories.isEmpty,
          orElse: () => true,
        );

    if (needsCategories) {
      await ref.read(categoriesProvider.notifier).getCategories();
    }

    if (!mounted) return;

    if (ref.read(categorySelectedProvider) == null) {
      await ref.read(categorySelectedProvider.notifier).setDefault();
    }

    if (!mounted) return;

    await ref.read(channelsLoadedProvider.notifier).get();
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
          title: 'IPTV',
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
              Expanded(child: _channelsArea(channels)),
            ],
          ),
        ));
  }

  /// Regla 1 (docs/REGLAS.md): cargando, exito, vacio y error, todos visibles.
  Widget _channelsArea(ContentState<List<Channel>> channels) {
    return ApiStateView<List<Channel>>(
      state: channels,
      onRetry: _load,
      emptyMessage: 'No hay canales en esta categoría.',
      builder: (list) => ChannelsList(
        listType: listType,
        channels: list,
      ),
    );
  }
}
