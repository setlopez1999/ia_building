import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/providers/connectivity/internet_check_provider.dart';
import 'package:tvapp/ui/screens/initial_loader/initial_loader.screen.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({super.key});

  static const name = '/no-internet';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset(
          AppAssets.logoOneplay,
          width: MediaQuery.of(context).size.width * (Environment.splashWidth),
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.signal_wifi_off_sharp,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  '¡No hay conexión\na internet!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(64),
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      final isConnected = await ref.watch(internetCheckProvider.notifier).checkConnectivity();
                      if(isConnected && context.mounted) {
                        context.replaceNamed(InitialLoaderScreen.name);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(18),
                      child: Text('Verificar conexión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
