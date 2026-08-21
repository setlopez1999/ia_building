import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({super.key, required this.videoController});

  final BetterPlayerController videoController;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: videoController.getAspectRatio() ?? 16/9,
        child: BetterPlayer(
            controller: videoController
        ));
  }
}
