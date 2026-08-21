import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/providers/selected_tab/selected_tab.provider.dart';
import 'package:tvapp/ui/screens/home/widgets/icon_vertical_button.widget.dart';

class BottomBarWidget extends ConsumerStatefulWidget {
  const BottomBarWidget({super.key});

  @override
  ConsumerState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends ConsumerState<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(selectedTabProvider);
    final currentTabNotifier = ref.read(selectedTabProvider.notifier);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconVerticalButton(
                onPressed: () {
                  currentTabNotifier.value(0);
                },
                selected: currentTab == 0,
                iconPath: 'assets/icons/home.png',
                text: 'Inicio',
              ),
              IconVerticalButton(
                onPressed: () {
                  currentTabNotifier.value(1);
                },
                selected: currentTab == 1,
                iconPath: 'assets/icons/channels.png',
                text: 'Canales',
              ),
              IconVerticalButton(
                onPressed: () {
                  currentTabNotifier.value(2);
                },
                selected: currentTab == 2,
                iconPath: 'assets/icons/fav.png',
                text: 'Favoritos',
              ),
              IconVerticalButton(
                onPressed: () {
                  currentTabNotifier.value(3);
                },
                selected: currentTab == 3,
                iconPath: 'assets/icons/account.png',
                text: 'Cuenta',
              )
            ],
          ),
        ),
      ),
    );
  }
}
