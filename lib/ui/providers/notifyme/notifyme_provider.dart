import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/notifications/create_notifyme_use_case.dart';
import 'package:tvapp/core/application/use_cases/notifications/get_notifymes_use_case.dart';
import 'package:tvapp/core/domain/entities/epg/epg_entity.dart';
import 'package:tvapp/core/domain/entities/notifyme/notifyme_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';

part 'notifyme_provider.g.dart';

@riverpod
class NotifyMe extends _$NotifyMe {

  @override
  final state = const ContentState.initial();

  @override
  ContentState<List<NotifymeEntity>> build() {
    return const ContentState.initial();
  }

  Future<void> createNotification(StreamEntity stream, Epg epg) async {
    final useCase = CreateNotifymeUseCase(ref.read(notificationRepositoryProvider));

    await ref.read(authProvider)
        .maybeWhen(
      success: (user) async {
        final startTime = DateFormat('HH:mm').format(
            DateTime.fromMillisecondsSinceEpoch(epg.fecha_ini * 1000));
        return useCase.execute(NotifymeEntity(
            cn_id: stream.channel.studio,
            text: 'No te pierdas ${epg.titulo} en ${stream.channel.title} a las $startTime',
            user_id: int.parse(user.us_id),
            scheduled_date: DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(
                DateTime.fromMillisecondsSinceEpoch(epg.fecha_ini * 1000).subtract(const Duration(minutes: 10))),
            key: '${epg.fecha_ini}_${epg.fecha_fin}_${stream.channel.studio}'
        ));
      },
      error: (err) {
        state = ContentState.error(err);
      },
      orElse: () => null,
    );
  }

  Future<void> getNotifications() async {
    final useCase = GetNotifymesUseCase(ref.read(notificationRepositoryProvider));

    final result = await useCase.execute();

    result.fold(
      (l) => null,
      (r) => state = ContentState.success(r),
    );

  }
}