import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/application/use_cases/content/get_categories_use_case.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';

part 'category_provider.g.dart';

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  ContentState<List<Category>> build() => const ContentState.initial();

  Future<void> getCategories() async {
    state = const ContentState.loading();
    final useCase = GetCategoriesUseCase(ref.read(categoryRepositoryProvider));
    await ref.read(authProvider).maybeWhen(
      success: (user) async {
        final result = await useCase.execute(user.token);
        result.fold(
          (error) => state = ContentState.error(error),
          (content) {
            state = ContentState.success(content);
            final selectedCategory = ref.read(categorySelectedProvider);
            if (selectedCategory == null) {
              ref.read(categorySelectedProvider.notifier).selectCategory(content.first);
            }
          },
        );
      },
      orElse: () {},
    );
  }
}
