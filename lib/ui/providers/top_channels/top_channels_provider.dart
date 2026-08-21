import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/content/get_top_channels_use_case.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';

part 'top_channels_provider.g.dart';

@riverpod
class TopChannels extends _$TopChannels {

  @override
  ContentState<List<Channel>> build() {
    return const ContentState.initial();
  }

  Future<void> get() async {
    state = const ContentState.loading();
    final useCase = GetTopChannelsUseCase(ref.read(topChannelsRepositoryProvider));
    await ref.read(authProvider).maybeWhen(
      success: (user) async {
        try {
          final result = await useCase.execute(user.us_id);
          result.fold(
                (error) => state = ContentState.error(error),
                (content) => state = ContentState.success(content),
          );
        } catch (e) {
          state = ContentState.error(AppException(
            statusCode: 4001,
            message: e.toString(),
            identifier: 'Error',
          ));
        }
      },
      orElse: () {},
    );
  }
}