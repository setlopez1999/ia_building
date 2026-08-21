import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';

class ChromecastButton extends StatefulWidget {
  const ChromecastButton({
    super.key,
    required this.onPressed
  });

  final void Function({required bool connected}) onPressed;

  @override
  State<ChromecastButton> createState() => _ChromecastButtonState();
}

class _ChromecastButtonState extends State<ChromecastButton> {

  GoogleCastConnectState castConnectionState = GoogleCastConnectState.disconnected;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      return const SizedBox();
    }


    return StreamBuilder<GoogleCastSession?>(
        stream: GoogleCastSessionManager.instance.currentSessionStream,
        builder: (context, snapshot) {

          Future.microtask((){
            setState(() {
              castConnectionState = GoogleCastSessionManager.instance.connectionState;
            });
          });

          final bool isConnected = GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected;
          return IconButton(onPressed: () async {

            if(isConnected) {
              await GoogleCastSessionManager.instance.endSessionAndStopCasting();
              widget.onPressed(connected: false);
              return;
            }

            await GoogleCastDiscoveryManager.instance.startDiscovery();
            widget.onPressed(connected: true);
          }, icon: Icon(isConnected ? Icons.cast_connected : Icons.cast, color: Colors.white));
        });
  }
}
