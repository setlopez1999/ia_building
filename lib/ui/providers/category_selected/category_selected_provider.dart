import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/ui/providers/category/category_provider.dart';
import 'package:tvapp/ui/providers/channels_loaded/channels_loaded_provider.dart';

part 'category_selected_provider.g.dart';

@Riverpod(keepAlive: true)
class CategorySelected extends _$CategorySelected {
  @override
  Category? build() => null;

  Future<void> selectCategory(Category category) async {

    if(category.id == state?.id){
      return;
    }
    state = category;
    await ref.read(channelsLoadedProvider.notifier).get();
  }

  Future<void> setDefault() async {
    ref.read(categoriesProvider)
    .maybeWhen(
        orElse: () => null,
        success: (categories){
          state = categories[0];
        }
    );
  }

  Future<void> nextCategory() async {
    await ref.read(categoriesProvider)
    .maybeWhen(
        orElse: () => null,
        success: (categories) async {
          final index = categories.indexWhere((element) => element.id == state?.id);
          if(index == -1) {
            return;
          }
          if(index == categories.length - 1) {
            await selectCategory(categories[0]);
            return;
          }
          await selectCategory(categories[index + 1]);
        }
    );
  }

  Future<void> prevCategory() async {
    await ref.read(categoriesProvider)
        .maybeWhen(
        orElse: () => null,
        success: (categories) async {
          final index = categories.indexWhere((element) => element.id == state?.id);
          if(index == -1) return;
          if(index == 0) {
            await selectCategory(categories[categories.length - 1]);
            return;
          }
          await selectCategory(categories[index - 1]);
        }
    );
  }
}