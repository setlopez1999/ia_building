import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/domain/entities/products/associated_product.dart';
import 'package:tvapp/core/domain/repositories/associated_products_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/associated_products_demo_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/associated_products_http_repository.dart';

/// Única decisión sobre de dónde salen los productos. La UI no sabe nada de
/// esto: consume la interfaz.
final associatedProductsRepositoryProvider =
    Provider<AssociatedProductsRepository>((ref) {
  return Environment.demoMode
      ? AssociatedProductsDemoRepository()
      : AssociatedProductsHttpRepository();
});

class AssociatedProductsNotifier
    extends Notifier<ContentState<List<AssociatedProduct>>> {
  @override
  ContentState<List<AssociatedProduct>> build() =>
      const ContentState.initial();

  Future<void> load() async {
    state = const ContentState.loading();
    final result =
        await ref.read(associatedProductsRepositoryProvider).getProducts();
    result.fold(
      (error) => state = ContentState.error(error),
      (products) => state = ContentState.success(products),
    );
  }
}

final associatedProductsProvider = NotifierProvider<
    AssociatedProductsNotifier, ContentState<List<AssociatedProduct>>>(
  AssociatedProductsNotifier.new,
);

/// Producto elegido para la pantalla de detalle.
class SelectedProductNotifier extends Notifier<AssociatedProduct?> {
  @override
  AssociatedProduct? build() => null;

  void select(AssociatedProduct product) => state = product;
}

final selectedProductProvider =
    NotifierProvider<SelectedProductNotifier, AssociatedProduct?>(
  SelectedProductNotifier.new,
);
