import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/providers/guide/guide_provider.dart';
import 'package:tvapp/ui/providers/selected_tab/selected_tab.provider.dart';
import 'package:tvapp/ui/screens/account/account_screen.dart';
import 'package:tvapp/ui/screens/channels/channels_screen.widget.dart';
import 'package:tvapp/ui/screens/favorites/favorites.screen.dart';
import 'package:tvapp/ui/screens/home/widgets/body.widget.dart';
import 'package:tvapp/ui/shared/layout/bottom_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';

/// Home Screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static String path = '/home';
  static String name = 'Home';

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Variables
  int selectedWishListCategory = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask((){ref.read(guideProvider.notifier).get();});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseButtonChannel.working = false;
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: _selectedTab(),
      ),
      bottomNavigationBar: const BottomBarWidget(),
    ));
  }

  Widget _selectedTab() {
    final currentTab = ref.watch(selectedTabProvider);
    switch (currentTab) {
      case 1:
        return const ChannelsScreen();
      case 2:
        return const FavoritesScreen();
      case 3:
        return const MyAccountScreen();
      default:
        return const BodyHome();
    }
  }
}
