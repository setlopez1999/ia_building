import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/products/associated_products_provider.dart';
import 'package:tvapp/ui/screens/products/associated_products_screen.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/product_status_chip.dart';

/// Detalle del producto: mismo modelo que la tarjeta, con los campos que la
/// lista no muestra (texto largo, información de pago y nota al pie).
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});

  static String name = 'product-detail';
  static String path = '/products/detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(selectedProductProvider);

    if (product == null) {
      return Scaffold(
        appBar: customAppBar(context, title: 'Detalle del producto'),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'No hay un producto seleccionado.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Detalle del producto',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: ProductStatusChip(status: product.status)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ProductImage(url: product.imageUrl, height: 160),
            ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            if (product.subtitle.isNotEmpty)
              Text(
                product.subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (product.priceLabel.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                product.priceLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (product.description.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                product.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: AppColors.textBody,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 22),
            if (product.paymentInfo.isNotEmpty)
              _PaymentPanel(info: product.paymentInfo),
            if (product.footerNote.isNotEmpty) ...[
              const SizedBox(height: 40),
              Text(
                product.footerNote,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Información del pago": panel desplegable, como en el diseño.
class _PaymentPanel extends StatefulWidget {
  const _PaymentPanel({required this.info});

  final String info;

  @override
  State<_PaymentPanel> createState() => _PaymentPanelState();
}

class _PaymentPanelState extends State<_PaymentPanel> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Información del pago',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: AppColors.containerDark,
                    child: Icon(
                      _open ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  widget.info,
                  style: const TextStyle(
                    color: AppColors.textBody,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
