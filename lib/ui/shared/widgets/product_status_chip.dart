import 'package:flutter/material.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/products/associated_product.dart';
import 'package:tvapp/core/theme/app_colors.dart';

/// Chip de estado del producto. Se usa igual en la tarjeta de la lista y en la
/// barra del detalle.
class ProductStatusChip extends StatelessWidget {
  const ProductStatusChip({super.key, required this.status});

  final ProductStatus status;

  Color get _color {
    switch (status) {
      case ProductStatus.activo:
        return Environment.actionColor;
      case ProductStatus.pendiente:
        return AppColors.warning;
      case ProductStatus.inactivo:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
