/// Categorías de "Otros productos asociados". Agregar una pestaña nueva es
/// agregar un valor acá: la lista, el detalle y el filtrado no cambian.
enum ProductCategory {
  streaming('Streaming', 'Tus productos de Streaming'),
  gaming('Gaming', 'Tus productos de Gaming'),
  asistenciaMascotas('Asistencia. Mascotas', 'Tus productos de Asistencia');

  const ProductCategory(this.label, this.sectionTitle);

  /// Texto de la pestaña.
  final String label;

  /// Encabezado que se muestra sobre la lista de esa pestaña.
  final String sectionTitle;

  static ProductCategory? fromApi(String? value) {
    if (value == null) return null;
    final v = value.trim().toLowerCase();
    for (final c in ProductCategory.values) {
      if (c.name.toLowerCase() == v || c.label.toLowerCase() == v) return c;
    }
    return null;
  }
}

/// Estado del producto tal como lo muestra el chip de la tarjeta.
enum ProductStatus {
  activo('Activo'),
  inactivo('Inactivo'),
  pendiente('Pendiente');

  const ProductStatus(this.label);
  final String label;

  static ProductStatus fromApi(String? value) {
    final v = (value ?? '').trim().toLowerCase();
    return ProductStatus.values.firstWhere(
      (s) => s.name == v || s.label.toLowerCase() == v,
      orElse: () => ProductStatus.inactivo,
    );
  }
}

/// Un producto asociado. El mismo modelo alimenta la tarjeta de la lista y la
/// pantalla de detalle: la lista usa los primeros campos, el detalle los usa
/// todos.
class AssociatedProduct {
  const AssociatedProduct({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.status,
    this.imageUrl = '',
    this.priceLabel = '',
    this.description = '',
    this.paymentInfo = '',
    this.footerNote = '',
  });

  final String id;
  final ProductCategory category;

  /// Lista y detalle.
  final String title;
  final String subtitle;
  final ProductStatus status;
  final String imageUrl;
  final String priceLabel;

  /// Solo detalle.
  final String description;
  final String paymentInfo;
  final String footerNote;

  factory AssociatedProduct.fromJson(Map<String, dynamic> json) {
    return AssociatedProduct(
      id: (json['id'] ?? '').toString(),
      category: ProductCategory.fromApi(json['categoria']?.toString()) ??
          ProductCategory.streaming,
      title: (json['titulo'] ?? '').toString(),
      subtitle: (json['subtitulo'] ?? '').toString(),
      status: ProductStatus.fromApi(json['estado']?.toString()),
      imageUrl: (json['imagen'] ?? '').toString(),
      priceLabel: (json['precio'] ?? '').toString(),
      description: (json['descripcion'] ?? '').toString(),
      paymentInfo: (json['informacion_pago'] ?? '').toString(),
      footerNote: (json['nota'] ?? '').toString(),
    );
  }
}
