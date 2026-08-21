import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/error_handler/domain_exception.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/auth/get_session_use_case.dart';
import 'package:tvapp/core/application/use_cases/content/get_stream_use_case.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/providers/channels_loaded/channels_loaded_provider.dart';
import 'package:tvapp/ui/providers/multicdn/multicdn_provider.dart';

part 'channel_playing_provider.g.dart';

@Riverpod(keepAlive: true)
class ChannelPlaying extends _$ChannelPlaying {

  @override
  ContentState<StreamEntity> build() => const ContentState.initial();

  Future<void> setChannel(Channel channel, {bool silent = false, bool fromHome = false}) async {
    if(!silent) {
      state = const ContentState.loading();
    }
    final channelsRepository = ref.read(channelsRepositoryProvider);
    final getStreamUseCase = GetStreamUseCase(channelsRepository);
    final sessionUseCase = GetSessionUseCase(ref.read(authRepositoryProvider));

    final session = await sessionUseCase.execute();
    String multiCdnUrl = '';

    if(Environment.multicdnEnabled) {
      multiCdnUrl = ref.read(multiCDNProvider.notifier).state
          .maybeMap<String>(
            success: (r) => r.content,
            orElse: () => ''
      );
    }

    await session.fold((error) => null, (session) async {
      final result = await getStreamUseCase.execute(session.token, channel, multiCdnUrl);
      result.fold(
        (error) => state = ContentState.error(error),
        //como no tenemos una propiedad para saber si el evento se origino en el player usaremos la propiedad cdn con valor 2
        (stream) => state = ContentState.success(stream.copyWith(cdn: fromHome ? 2 : 0)),
      );
    });
  }

  Future<void> toRight() async  {
    await ref.read(channelsLoadedProvider)
    .maybeWhen(
      success: (channels) async {
        await state.maybeWhen(
          success: (stream) async {
            final index = (channels as List<Channel>)
                .indexWhere((element) => element.studio == (stream as StreamEntity).channel.studio);

            //ERROR: CANAL NO ENTONCTRADO
            if(index == -1) return;

            if(index == channels.length - 1) {
              await nextCategory();
              return;
            }

            await setChannel(channels[index + 1], silent: true);

          },
          orElse: () => null
        );
      },
      orElse: () => null
    );
  }

  Future<void> toLeft() async {
    await ref.read(channelsLoadedProvider)
        .maybeWhen(
        success: (channels) async {
          await state.maybeWhen(
              success: (stream) async {
                final index = (channels as List<Channel>)
                    .indexWhere((element) => element.studio == (stream as StreamEntity).channel.studio);

                //ERROR: CANAL NO ENTONCTRADO
                if(index == -1) return;

                if(index == 0) {
                  await prevCategory();
                  return;
                }

                await setChannel(channels[index - 1], silent: true);

              },
              orElse: () => null
          );
        },
        orElse: () => null
    );
  }

  Future<void> nextCategory() async {
    await ref.read(categorySelectedProvider.notifier).nextCategory();
    await ref.read(channelsLoadedProvider).maybeWhen(orElse: () => null, success: (channels) => setChannel(channels[0], silent: true));
  }

  Future<void> prevCategory() async {
    await ref.read(categorySelectedProvider.notifier).prevCategory();
    await ref.read(channelsLoadedProvider).maybeWhen(orElse: () => null, success: (channels) => setChannel(channels[channels.length - 1], silent: true));
  }

  Future<void> listenChannelChanges() async {
    try {
      // Get current stream from state
      final currentStream = state.maybeWhen(
        success: (stream) => stream as StreamEntity,
        orElse: () => null,
      );

      if (currentStream == null) {
        return;
      }

      // Get session token
      final sessionResult = await GetSessionUseCase(ref.read(authRepositoryProvider)).execute();
      final token = sessionResult.getRight().fold(
            () => '',
            (session) => session.token,
      );

      if (token.isEmpty) {
        return;
      }

      String multiCdnUrl = '';

      if(Environment.multicdnEnabled) {
        multiCdnUrl = ref.read(multiCDNProvider.notifier).state
            .maybeMap<String>(
            success: (r) => r.content,
            orElse: () => ''
        );
      }

      // Get new stream data
      final newStreamResult = await GetStreamUseCase(ref.read(channelsRepositoryProvider))
          .execute(token, currentStream.channel, multiCdnUrl);

      return newStreamResult.fold(
            (error) => false,
            (newStream) {
              if (newStream.link != currentStream.link) {
                 setChannel(currentStream.channel, silent: true);
              }
            },
      );
    } catch (e) {
      return;
    }
  }
}
