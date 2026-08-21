import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/providers/notification_selected/notification_selected_provider.dart';
import 'package:tvapp/ui/shared/widgets/category_chip.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({
    super.key,
    required this.categories,
    required this.categoryActive,
    required this.onTap,
  });

  final List<Category> categories;
  final Category categoryActive;
  final Function(Category category) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsCategoriesItemScrollController = ItemScrollController();
    final initialIndex = categories.indexWhere((element) => element.id == categoryActive.id);

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white38,
          ),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: ScrollablePositionedList.separated(
        itemScrollController: channelsCategoriesItemScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        initialScrollIndex: initialIndex == -1 ? 0 : initialIndex,
        initialAlignment: 0.38,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          return CategoryChip(
              category: category,
              categoryActive: categoryActive.id,
              onPressed: () {
                channelsCategoriesItemScrollController.scrollTo(
                  index: index,
                  duration: const Duration(milliseconds: 300),
                  alignment: 0.38,
                );
                onTap(category);
              });
        },
      ),
    );
  }
}
