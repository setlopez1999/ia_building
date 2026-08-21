import 'package:flutter/material.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class ChromecastLoader extends StatelessWidget {
  const ChromecastLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          right: false,
          left: false,
          bottom: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                GoogleTextWidget('Cargando Chromecast',style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
