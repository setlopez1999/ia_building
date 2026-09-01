import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/products/associated_product.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/products/associated_products_provider.dart';
import 'package:tvapp/ui/screens/products/product_detail_screen.dart';
import 'package:tvapp/ui/shared/widgets/api_state.widget.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/product_status_chip.dart';

/// Otros productos asociados: una pestaña por [ProductCategory].
///
/// Las pestañas salen del enum, así que agregar una categoría no toca esta
/// pantalla. El mismo producto puede aparecer en más de una pestaña porque el
/// filtrado es por categoría, no por posición.
class AssociatedProductsScreen extends ConsumerStatefulWidget {
  const AssociatedProductsScreen({super.key});

  static String name = 'associated-products';
  static String path = '/products';

  @override
  ConsumerState<AssociatedProductsScreen> createState() =>
      _AssociatedProductsScreenState();
}

class _AssociatedProductsScreenState
    extends ConsumerState<AssociatedProductsScreen> {
  ProductCategory _tab = ProductCategory.values.first;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    await ref.read(associatedProductsProvider.notifier).load();
  }

  void _openDetail(AssociatedProduct product) {
    ref.read(selectedProductProvider.notifier).select(product);
    context.pushNamed(ProductDetailScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(associatedProductsProvider);

    return Scaffold(
      appBar: customAppBar(context, title: 'Otros productos asociados'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryTabs(
            active: _tab,
            onTap: (tab) => setState(() => _tab = tab),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _tab.sectionTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            // Regla 1: cargando, vacío y error, todos visibles.
            child: ApiStateView<List<AssociatedProduct>>(
              state: state,
              onRetry: _load,
              emptyMessage: 'Todavía no tienes productos asociados.',
              builder: (todos) {
                final productos =
                    todos.where((p) => p.category == _tab).toList();

                if (productos.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'No tienes productos de ${_tab.label}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 15),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: productos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final product = productos[index];
                    return _ProductCard(
                      product: product,
                      onTap: () => _openDetail(product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.active, required this.onTap});

  final ProductCategory active;
  final ValueChanged<ProductCategory> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: ProductCategory.values.map((tab) {
          final isActive = tab == active;
          return GestureDetector(
            onTap: () => onTap(tab),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isActive ? Environment.actionColor : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                tab.label,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white : Colors.white54,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Tarjeta de la lista: imagen arriba, y debajo título, subtítulo, precio y
/// el chip de estado.
class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final AssociatedProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          color: AppColors.container,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(url: product.imageUrl, height: 130),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.subtitle.isNotEmpty)
                                Text(
                                  product.subtitle,
                                  style: const TextStyle(
                                      color: AppColors.textBody, fontSize: 12),
                                ),
                              if (product.priceLabel.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  product.priceLabel,
                                  style: const TextStyle(
                                      color: AppColors.textBody, fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        ),
                        ProductStatusChip(status: product.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Imagen del producto con respaldo cuando no hay URL o falla la carga.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, required this.height});

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: double.infinity,
      color: AppColors.containerDark,
      child: const Icon(Icons.widgets_outlined, color: Colors.white24, size: 40),
    );

    if (url.trim().isEmpty) return placeholder;

    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
