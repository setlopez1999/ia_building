import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/ui/providers/notifyme/notifyme_provider.dart';
import 'package:tvapp/ui/screens/player/player_enums.dart';

class Catchup extends ConsumerWidget {
  const Catchup({super.key, required this.stream, required this.onEpgSelected});

  final StreamEntity stream;
  final Function(Epg epg, CatchupStatus status) onEpgSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifymeState = ref.watch(notifyMeProvider);
    final filterStream = getFilteredStream(stream);
    final initialIndex = filterStream.epg.indexWhere((element) => checkTimeStatus(element) == CatchupStatus.playing);

    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: notifymeState.maybeWhen(
            success: (notifications) {
              return ScrollablePositionedList.separated(
                  separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.white38,),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filterStream.epg.length,
                  initialScrollIndex: initialIndex != -1 ? initialIndex : 0,
                  initialAlignment: 0.4,
                  itemBuilder: (BuildContext context, int index) {
                    final scheduleItem = filterStream.epg[index];

                    if (scheduleItem.titulo == 'empty') {
                      return _catchupNotEnabled();
                    }

                    final startTime = DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            scheduleItem.fecha_ini * 1000));
                    final endTime = DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            scheduleItem.fecha_fin * 1000));

                    final textColor = getTextColor(checkTimeStatus(scheduleItem));
                    final key = '${scheduleItem.fecha_ini}_${scheduleItem.fecha_fin}_${stream.channel.studio}';
                    final keyExist = notifications
                        .where((element) => element.key == key)
                        .toList()
                        .isNotEmpty;

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(scheduleItem.titulo,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 2, bottom: 5),
                                    child: Text(
                                      '$startTime - $endTime hrs',
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  getStatusButton(scheduleItem, ref, keyExist)
                                ],
                              )),
                        ]);
                  });
            },
            orElse: () {
              Future.microtask(() async {
                await ref.read(notifyMeProvider.notifier).getNotifications();
              });
              return const CircularProgressIndicator();
            }
          ),
        ));
  }

  Widget _catchupNotEnabled() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 30, bottom: 150),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/no_replay.png', width: 40, height: 40),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Este canal no tiene disponible',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              Text('la funcionalidad de Catch UP',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

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

  StreamEntity getFilteredStream(StreamEntity stream) {
    const emptyEpg = Epg(
        titulo: 'empty',
        anterior: '',
        fecha_fin: 0,
        desc: '',
        fecha_ini: 0,
        run: 0,
        siguiente: '');

    if(stream.catchupEnabled){
      return stream.copyWith(epg: stream.epg.reversed.toList());
    }

    return stream.copyWith(epg: [
      emptyEpg,
    ]);
  }

  Color getTextColor(CatchupStatus status) {
    switch (status) {
      case CatchupStatus.playing:
        return Colors.white;
      case CatchupStatus.finished:
        return Colors.white;
      case CatchupStatus.notStarted:
        return Colors.white38;
    }
  }
  
  Widget getStatusButton(Epg scheduleItem, WidgetRef ref, bool keyExists) {

    Color? backgroundColorBtn = Colors.green;
    String textBtn = 'Notifícame';
    IconData? iconBtn = Icons.notifications_none;
    final statusSchedule = checkTimeStatus(scheduleItem);

    if (statusSchedule == CatchupStatus.finished) {
      backgroundColorBtn = Colors.white;
      textBtn = 'Volver a ver';
      iconBtn = Icons.smart_display_outlined;
    }
    if (statusSchedule == CatchupStatus.playing) {
      backgroundColorBtn = Colors.red;
      textBtn = 'En vivo';
      iconBtn = Icons.circle;
    }

    if (keyExists && statusSchedule == CatchupStatus.notStarted) {
      backgroundColorBtn = Colors.grey;
      textBtn = 'Agendado';
      iconBtn = Icons.notifications_active;
    }

    if(statusSchedule == CatchupStatus.notStarted && !Environment.notificationCatchupEnabled) {
      return const SizedBox();
    }

    return SizedBox(
      height: 20,
      child:
      !stream.catchupEnabled && statusSchedule == CatchupStatus.finished
          ? null
          : ElevatedButton.icon(
        onPressed: () async  {
          if(statusSchedule == CatchupStatus.notStarted && !keyExists) {
            await ref.read(notifyMeProvider.notifier).createNotification(stream, scheduleItem);
            await ref.read(notifyMeProvider.notifier).getNotifications();
          }
          onEpgSelected(scheduleItem,statusSchedule);
        },
        icon: Icon(
          iconBtn,
          color: (statusSchedule ==
              CatchupStatus.finished)
              ? Colors.black
              : Colors.white,
          size: 14,
        ),
        label: Text(
          textBtn,
          style: TextStyle(
              color: (statusSchedule == CatchupStatus.finished)
                  ? Colors.black
                  : Colors.white,
              fontSize: 12,
              wordSpacing: 0.9,
              fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColorBtn,
          padding: const EdgeInsets.symmetric(
              horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      )
    );
  }
}
