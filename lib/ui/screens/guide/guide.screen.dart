import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';
import 'package:tvapp/ui/providers/guide/guide_provider.dart';
import 'package:tvapp/ui/screens/guide/guide_config.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/base_button_channel.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';


class GuideScreen extends ConsumerStatefulWidget {
  const GuideScreen({super.key});

  static String name = 'Tv guide';

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends ConsumerState<GuideScreen> {

  final verticalController = ScrollController();
  final listViewController = ScrollController();
  final horizontalController = ScrollController();
  double channelTitleWidth = 128;
  int fixedColumns = 0;
  double _previousOffset = 0;

  void jumpToNow() {
    if (verticalController.hasClients) {
      final now = DateTime.now();
      horizontalController
          .jumpTo((now.hour * 300) + (now.minute * 5).toDouble());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumpToNow();

      // Sincronizar el scroll del primer controlador
      verticalController.addListener(() {
        if (verticalController.position.pixels != listViewController.position.pixels) {
          listViewController.jumpTo(verticalController.position.pixels);
        }
      });

      // Sincronizar el scroll del segundo controlador
      listViewController.addListener(() {
        if (listViewController.position.pixels != verticalController.position.pixels) {
          verticalController.jumpTo(listViewController.position.pixels);
        }
      });

      horizontalController.addListener(() {
        // Obtener la posición actual del scroll
        final currentOffset = horizontalController.position.pixels;

        // Scroll de derecha a izquierda (reducir tamaño)
        if (currentOffset > _previousOffset) {
          final diff = currentOffset - _previousOffset;

          if(channelTitleWidth > 0) {
            setState(() {
              final width = channelTitleWidth - diff;
              if(width > 0) {
                channelTitleWidth -= diff;
              }
            });
          }
        }
        // Scroll de izquierda a derecha (aumentar tamaño)
        else if (currentOffset < _previousOffset) {
          // Verificar si estamos cerca del inicio (200px)
          if (currentOffset <= 200) {
            final diff = _previousOffset - currentOffset;

            setState(() {
              final newWidth = channelTitleWidth + diff;
              // Limitar el máximo a 128
              channelTitleWidth = newWidth.clamp(0.0, 128.0);
            });
          }
        }

        // Actualizar la posición anterior
        _previousOffset = currentOffset;
      });
    });


  }

  @override
  void dispose() {
    horizontalController.dispose();
    verticalController.dispose();
    listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final epgState = ref.watch(guideProvider);
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context, title: 'Guía de programación'),
        body: epgState.when(
            success: (epg) {
              return Row(
                children: [
                  _buildChannelsListView(epg, context),
                  Expanded(
                    child: _buildTableView(
                        epg, verticalController, horizontalController, ref, context),
                  ),
                ],
              );
            },
            error: (error) {
              return const GoogleTextWidget('');
            },
            loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.secondaryColor(context),
                  ),
                ),
            initial: () {
              Future.microtask(() => ref.read(guideProvider.notifier).get());
              return const GoogleTextWidget('');
            }),
      ),
    );
  }

  TableView _buildTableView(
      List<Channel> epg,
      ScrollController verticalController,
      ScrollController horizontalController,
      WidgetRef ref,
      BuildContext context) {
    return TableView.builder(
      cellBuilder: (context, vicinity) =>
          _buildCell(vicinity, epg, ref, context),
      horizontalDetails:
          ScrollableDetails.horizontal(controller: horizontalController),
      verticalDetails:
          ScrollableDetails.vertical(controller: verticalController),
      columnCount: GuideConfig.TIMES.length + fixedColumns,
      columnBuilder: _buildColumn,
      rowCount: epg.length + 1, // +1 for header
      rowBuilder: _buildRow,
      pinnedColumnCount: fixedColumns,
      pinnedRowCount: 1, // header fixed (program times)
      cacheExtent: 10,
    );
  }

  TableViewCell _buildCell(TableVicinity vicinity, List<Channel> epg,
      WidgetRef ref, BuildContext context) {
    if (vicinity.row == 0) {
      return _buildHeaderCell(vicinity);
    }
    return _buildProgramCell(epg[vicinity.row - 1]);
  }

  TableViewCell _buildHeaderCell(TableVicinity vicinity) {
    return TableViewCell(
      child: GoogleTextWidget(GuideConfig.TIMES[vicinity.column - fixedColumns], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  TableViewCell _buildProgramCell(Channel channel) {
    return TableViewCell(
      columnMergeSpan: GuideConfig.TIMES.length,
      columnMergeStart: fixedColumns,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final totalWidth =
              (GuideConfig.BASE_HALF_HOUR * GuideConfig.TIMES.length)
                  .toDouble();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalWidth > constraints.maxWidth
                  ? totalWidth
                  : constraints.maxWidth,
              height: 64,
              child: Stack(
                children: channel.epg!.map(_buildProgramItem).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Positioned _buildProgramItem(Epg element) {
    final ini = DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(element.fecha_ini * 1000));
    final end = DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(element.fecha_fin * 1000));
    return Positioned(
      left: _getOffset(element.fecha_ini) - 1,
      top: 0,
      child: Container(
        height: 62,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color.fromRGBO(66, 66, 66, 1),
        ),
        width: _getProgramWidth(element.fecha_ini, element.fecha_fin) - 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoogleTextWidget(element.titulo, maxLines: 1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
              GoogleTextWidget('$ini - $end', maxLines: 1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
      ),
    );
  }

  TableSpan _buildColumn(int index) {
    return TableSpan(
      foregroundDecoration: const TableSpanDecoration(
        border: TableSpanBorder(trailing: BorderSide()),
      ),
      extent: FixedTableSpanExtent(GuideConfig.BASE_HALF_HOUR.toDouble()),
      cursor: SystemMouseCursors.contextMenu,
    );
  }

  TableSpan _buildRow(int index) {

    return TableSpan(
      backgroundDecoration: const TableSpanDecoration(
        border: TableSpanBorder(trailing: BorderSide()),
      ),
      extent: FixedTableSpanExtent(index > 0 ? 64 : 20),
      cursor: SystemMouseCursors.click,
      padding: const SpanPadding(trailing: 5)
    );
  }

  double _getOffset(int fechaIni) {
    final init = DateTime.fromMillisecondsSinceEpoch(fechaIni * 1000);
    final now = DateTime.now();
    final offsetDate = DateTime(now.year, now.month, now.day);
    const baseMinutesOnPixels = 300;
    const hourOnMinutes = 60;

    var diff = init.difference(offsetDate).inMinutes;
    if (diff > 0) {
      diff++;
    }
    return (diff * baseMinutesOnPixels) / hourOnMinutes;
  }

  double _getProgramWidth(int fechaIni, int fechaFin) {
    final init = DateTime.fromMillisecondsSinceEpoch(fechaIni * 1000);
    var end = DateTime.fromMillisecondsSinceEpoch(fechaFin * 1000);
    final actualDay = DateTime.now().weekday;
    const pixelsOnMinute = 5;
    if (end.weekday != actualDay) {
      end = DateTime(
        end.year,
        end.month,
        init.day,
        23,
        59,
      );
    }

    final diff = end.difference(init).inMinutes;
    return (diff * pixelsOnMinute).toDouble();
  }

  Widget _buildChannelsListView(epg, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 132 + channelTitleWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ListView.builder(
          controller: listViewController,
          itemCount: epg.length,
          itemBuilder: (context, index) {
            final channel = epg[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  _buildChannelNumberCell(channel),
                  _buildChannelImageCell(channel, ref, context),
                  _buildChannelNameCell(channel, ref, context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChannelNumberCell(Channel channel) {
    return SizedBox(
      width: 64,
        height: 64,
        child: Center(child: GoogleTextWidget(channel.number.toString(), style: const TextStyle(fontSize: 14),)));
  }

  Widget _buildChannelNameCell(
      Channel channel, WidgetRef ref, BuildContext context) {
    return SizedBox(
      height: 64,
      width: channelTitleWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GoogleTextWidget(
                  channel.title,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelImageCell(
      Channel channel, WidgetRef ref, BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: NetworkImage(channel.card),
            width: 64, height: 64, fit: BoxFit.cover,
            child: InkWell(
              onTap: () {
                BaseButtonChannel.playChannel(channel: channel.copyWith(epg: []), ref: ref, context: context);
              },
          )
          ),
        )
    );
  }
}
