import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/content/get_channels_by_category_use_case.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';

part 'channels_loaded_provider.g.dart';

@Riverpod(keepAlive: true)
class ChannelsLoaded extends _$ChannelsLoaded {
  @override
  ContentState<List<Channel>> build() => const ContentState.initial();

  Future<void> get() async {
    state = const ContentState.loading();
    final useCase = GetChannelsByCategoryUseCase(ref.read(channelsRepositoryProvider));
    await ref.read(authProvider).maybeWhen(
      success: (user) async {
        final categorySelected = ref.read(categorySelectedProvider);
        final result = await useCase.execute(user.token, categorySelected!.id);
        result.fold(
          (error) => state = ContentState.error(error),
          (content) => state = ContentState.success(content),
        );
      },
      orElse: () {},
    );
  }
}
