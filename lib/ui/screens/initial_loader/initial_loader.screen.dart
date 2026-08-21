import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/screens/initial_loader/widgets/body.initial_loader.widget.dart';

/// Initial Loader Screen
class InitialLoaderScreen extends ConsumerStatefulWidget {
  const InitialLoaderScreen({super.key});

  static String name = 'Initial Loader Screen';

  @override
  ConsumerState createState() => _InitialLoaderScreenState();
}

class _InitialLoaderScreenState extends ConsumerState<InitialLoaderScreen> {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return const Scaffold(
      body: BodyWidget(),
    );
  }
}
