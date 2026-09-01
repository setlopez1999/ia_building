import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/products/associated_product.dart';
import 'package:tvapp/core/domain/repositories/associated_products_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

/// Datos de muestra para revisar el maquetado mientras el endpoint no existe.
///
/// ⚠️ Se usa **solo** con `DEMO=true` en el `.env`, y nunca en
/// release. No es un fallback silencioso: si el flag está apagado, la app
/// informa que no hay productos en vez de mostrar estos (Regla 4).
class AssociatedProductsDemoRepository implements AssociatedProductsRepository {
  static const _descripcion =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus dui '
      'eros, molestie mattis nisl sed, pulvinar pharetra nulla. Nam at est '
      'euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

  @override
  Future<Either<AppException, List<AssociatedProduct>>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return const Right([
      AssociatedProduct(
        id: 'hotgo',
        category: ProductCategory.streaming,
        title: 'HotGO',
        subtitle: 'Vigencia: 00-00-0000 al 00-00-0000',
        priceLabel: r'$12.500 CLP Mensual',
        status: ProductStatus.activo,
        description: _descripcion,
        paymentInfo: 'Cargo mensual automático a tu medio de pago registrado.',
        footerNote: 'Si deseas acceder a más plataformas de Streaming '
            'dirígete a www.empresa.com',
      ),
      AssociatedProduct(
        id: 'filmity',
        category: ProductCategory.streaming,
        title: 'Filmity',
        subtitle: 'Vigencia: 00-00-0000 al 00-00-0000',
        priceLabel: r'$12.500 CLP Mensual',
        status: ProductStatus.activo,
        description: _descripcion,
        paymentInfo: 'Cargo mensual automático a tu medio de pago registrado.',
        footerNote: 'Si deseas acceder a más plataformas de Streaming '
            'dirígete a www.empresa.com',
      ),
      AssociatedProduct(
        id: 'gaming-pass',
        category: ProductCategory.gaming,
        title: 'Gaming Pass',
        subtitle: 'Vigencia: 00-00-0000 al 00-00-0000',
        priceLabel: r'$9.900 CLP Mensual',
        status: ProductStatus.pendiente,
        description: _descripcion,
        paymentInfo: 'Pendiente de confirmación de pago.',
        footerNote: 'Si deseas acceder a más planes de Gaming '
            'dirígete a www.empresa.com',
      ),
      AssociatedProduct(
        id: 'cloud-play',
        category: ProductCategory.gaming,
        title: 'Cloud Play',
        subtitle: 'Vigencia: 00-00-0000 al 00-00-0000',
        priceLabel: r'$14.900 CLP Mensual',
        status: ProductStatus.activo,
        description: _descripcion,
        paymentInfo: 'Cargo mensual automático a tu medio de pago registrado.',
        footerNote: 'Si deseas acceder a más planes de Gaming '
            'dirígete a www.empresa.com',
      ),
      AssociatedProduct(
        id: 'asistencia-hogar',
        category: ProductCategory.asistenciaMascotas,
        title: 'Asistencia Hogar',
        subtitle: 'Vigencia: 00-00-0000 al 00-00-0000',
        priceLabel: r'$6.500 CLP Mensual',
        status: ProductStatus.activo,
        description: _descripcion,
        paymentInfo: 'Incluye hasta 3 asistencias al año sin costo adicional.',
        footerNote: 'Si deseas contratar más coberturas '
            'dirígete a www.empresa.com',
      ),
      AssociatedProduct(
        id: 'mascota-protegida',
        category: ProductCategory.asistenciaMascotas,
        title: 'Mascota Protegida',
        subtitle: 'Vigencia: 00-00-0000 al 00-00-0000',
        priceLabel: r'$4.900 CLP Mensual',
        status: ProductStatus.inactivo,
        description: _descripcion,
        paymentInfo: 'Servicio suspendido por falta de pago.',
        footerNote: 'Si deseas contratar más coberturas '
            'dirígete a www.empresa.com',
      ),
    ]);
  }
}
