import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/providers/category/category_provider.dart';
import 'package:tvapp/ui/providers/category_selected/category_selected_provider.dart';
import 'package:tvapp/ui/providers/selected_tab/selected_tab.provider.dart';
import 'package:tvapp/ui/screens/home/widgets/category_grid_button.dart';
import 'package:tvapp/ui/screens/login/login.screen.dart';
import 'package:tvapp/ui/shared/utils/array_utils.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CategoriesGrid extends ConsumerStatefulWidget {
  const CategoriesGrid({super.key});

  @override
  CategoriesGridState createState() => CategoriesGridState();
}

class CategoriesGridState extends ConsumerState<CategoriesGrid> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoriesProvider.notifier).getCategories();
    });
  }


  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return categories.maybeWhen(
      orElse: () => const CircularProgressIndicator(),
      success: (categories) {
        final rowItems = getRowItems(categories, ref);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GoogleTextWidget('Categorías', style: TextStyle(fontSize: Environment.h2FSize, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14,
                children: rowItems,
              ),
            ),
          ],
        );
      },
      error: (error) {
        if(error.statusCode == 3001){
          Future.microtask(() async {
           await  ref.read(authProvider.notifier).logout();
          });
        }
        return const SizedBox();
      },
    );
  }

  /// Generar grilla de n x 4 categorias (filas de 4)
  List<Widget> getRowItems(List<Category> categories, WidgetRef ref) {
    final arrUtils = ArrayUtils<Category>();
    final chunkedCategories = arrUtils.chunk(categories, 4); // Agrupamos de 4 en 4
    final List<Widget> rowItems = [];

    for (final categoryRow in chunkedCategories){
      final List<Widget> rowChildren = [];

      for (final cat in categoryRow) {
        rowChildren.add(CategoryGridButton(category: cat, onPressed: (){
          ref.read(categorySelectedProvider.notifier).selectCategory(cat);
          ref.read(selectedTabProvider.notifier).value(1);
        }));
      }
      rowItems.add(Row(spacing: 14, children: rowChildren));
    }

    return rowItems;
  }
}
