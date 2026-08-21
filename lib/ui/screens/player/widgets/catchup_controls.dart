import 'package:flutter/material.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/ui/screens/player/player_enums.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CatchupControls extends StatelessWidget {
  const CatchupControls({
    super.key,
    required this.onBackPressed,
    required this.onScreenPressed,
    required this.epg,
    required this.stream,
    required this.sliderChild,
    this.onPlayPressed,
    required this.playerIcon, required this.onEpgChange
  });

  final VoidCallback onBackPressed;
  final VoidCallback onScreenPressed;
  final Function(Epg epg, CatchupStatus status) onEpgChange;
  final VoidCallback? onPlayPressed;
  final IconData playerIcon;
  final Epg epg;
  final StreamEntity stream;
  final Widget sliderChild;

  CatchupStatus checkTimeStatus(Epg epg) {
    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Si currentTimestamp está entre fecha_ini y fecha_fin
    if (epg.fecha_ini <= currentTimestamp && epg.fecha_fin >= currentTimestamp) {
      return CatchupStatus.playing;
    }

    // Si currentTimestamp es mayor que fecha_fin
    if (epg.fecha_fin < currentTimestamp) {
      return CatchupStatus.finished;
    }

    // Si currentTimestamp es menor que fecha_ini
    return CatchupStatus.notStarted;
  }

  @override
  Widget build(BuildContext context) {

    final index = stream.epg.indexWhere((element) => element.fecha_ini == epg.fecha_ini);
    final nextStatus = index <= stream.epg.length ? checkTimeStatus(stream.epg[index + 1]) : null;
    final prevStatus = index > 0 ? checkTimeStatus(stream.epg[index - 1]) : null;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 82,
          backgroundColor: Colors.black87,
          leading: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onBackPressed,
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GoogleTextWidget(epg.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        body: InkWell(
          onTap: onScreenPressed,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.black87,
          height: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: prevStatus != null ? () => onEpgChange(stream.epg[index - 1], prevStatus) : null,
                    highlightColor: Colors.white54,
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: onPlayPressed,
                    highlightColor: Colors.white54,
                    icon: Icon(
                      playerIcon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: nextStatus != null && nextStatus != CatchupStatus.notStarted ? () => onEpgChange(stream.epg[index + 1], nextStatus) : null,
                    highlightColor: Colors.white54,
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              sliderChild
            ],
          ),
        ),
      ),
    );
  }
}
