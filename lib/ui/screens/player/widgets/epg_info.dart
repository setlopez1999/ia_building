import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/ui/shared/widgets/favorite_button.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class EpgInfo extends StatelessWidget {
  const EpgInfo({super.key, required this.onBackPressed, required this.stream});

  final VoidCallback onBackPressed;
  final StreamEntity stream;

  @override
  Widget build(BuildContext context) {

    final epg = stream.epg.where((epg) {
      final ini = epg.fecha_ini * 1000;
      final fin = epg.fecha_fin * 1000;
      final now = DateTime.now().millisecondsSinceEpoch;
      return (now >= ini && now <= fin) || now < ini;
    }).toList();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        right: false,
        left: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 82,
            backgroundColor: Colors.black87,
            leading: IconButton(
              onPressed: onBackPressed,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GoogleTextWidget(
                    stream.channel.number.toString(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                  width: 55,
                  height: 55,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: stream.channel.card,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _createEpgItem('AHORA', stream.channel, context, epg.elementAtOrNull(0)),
                      ),
                      Expanded(
                        child: Opacity(opacity: 0.4,
                        child: _createEpgItem('PRÓXIMO', stream.channel, context, epg.elementAtOrNull(1))),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: InkWell(
            onTap: onBackPressed,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: const SizedBox.expand(),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.black87,
            height: 110,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoogleTextWidget(
                        stream.channel.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60,
                        ),
                      ),
                      GoogleTextWidget(
                        stream.channel.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                FavoriteButton(stream.channel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createEpgItem(String label, Channel channel, BuildContext context, Epg? epg) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GoogleTextWidget(
            label,
            style: const TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          GoogleTextWidget(
            epg != null
                ? epg.titulo
                : 'Programación de ${channel.title}',
            style: const TextStyle(
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            textAlign: TextAlign.left,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          _createProgressBar(context, epg),
          const SizedBox(height: 2),
          if (epg != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoogleTextWidget(
                  DateFormat('HH:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      epg.fecha_ini * 1000,
                    ).toLocal(),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GoogleTextWidget(
                  DateFormat('HH:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      epg.fecha_fin * 1000,
                    ).toLocal(),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          else
            const GoogleTextWidget('', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  LayoutBuilder _createProgressBar(BuildContext context, Epg? epg) {
    double progress = 0;

    if (epg != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final start = epg.fecha_ini * 1000;
      final end = epg.fecha_fin * 1000;

      final totalProgram = end - start;
      final timeElapsedFromStart = now - start;
      progress = timeElapsedFromStart / totalProgram;

      if (progress < 0) {
        progress = 0;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final lineWidth = constraints.maxWidth * progress;
        return Stack(
          children: [
            SizedBox(
              height: 8,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
              ),
            ),
            SizedBox(
              height: 8,
              width: lineWidth,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.secondaryColor(context)),
              ),
            )
          ],
        );
      },
    );
  }
}
