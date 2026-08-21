import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/ui/providers/channels_searched/channels_searched_provider.dart';
import 'package:tvapp/ui/screens/favorites/widgets/favorite_body.dart';
import 'package:tvapp/ui/screens/search/search.screen.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Favoritos',
        actions: [
          /// Search
          IconButton(
            onPressed: () {
              ref.read(channelsSearchedProvider.notifier).get(favorites: true);
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
      body: const FavoriteBody(),
    );
  }
}
