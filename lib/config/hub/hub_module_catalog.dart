import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/modulos/modulos_entity.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';

/// Identificadores de los módulos del hub.
enum HubModuleId {
  eventos,
  iptv,
  vod,
  camaras,
  clubDescuentos,
  checkHealth,
  mascotas,
}

class HubModule {

  const HubModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.svgAsset,
    this.isNew = false,
    this.isHealth = false,
  });
  final HubModuleId id;
  final String title;
  final String subtitle;
  final String svgAsset;
  final bool isNew;
  final bool isHealth;
}

/// Catálogo estático de módulos del hub + regla de visualización.
///
/// El backend decide QUÉ módulos se muestran (flags en /api/inicio);
/// este catálogo define CÓMO se ve cada uno.
class HubModuleCatalog {
  /// ÚNICO INTERRUPTOR: con `DEMO=true` en el .env se muestran todos los
  /// módulos sin importar los flags del backend. Con `DEMO=false` se obedece
  /// estrictamente la API y, si no vienen flags, no se muestra ninguno.
  ///
  /// Usa el mismo flag que el resto de las pantallas cuyo endpoint todavía no
  /// existe (productos, notificaciones). Antes dependía de `kDebugMode`, que
  /// no se puede configurar por ISP ni permite probar el comportamiento real
  /// desde una build de debug.
  static bool get showAll => Environment.demoMode;

  static const List<HubModule> all = [
    HubModule(
      id: HubModuleId.eventos,
      title: 'Eventos',
      subtitle: 'Deportes, conciertos y mas...',
      svgAsset: AppAssets.hubEventos,
    ),
    HubModule(
      id: HubModuleId.iptv,
      title: 'IPTV',
      subtitle: 'Canales para todos',
      svgAsset: AppAssets.hubTv,
    ),
    HubModule(
      id: HubModuleId.vod,
      title: 'VOD',
      subtitle: 'Entretenimiento',
      svgAsset: AppAssets.hubPlay,
    ),
    HubModule(
      id: HubModuleId.camaras,
      title: 'Cámaras',
      subtitle: 'Cuida tu hogar y a los tuyos',
      svgAsset: AppAssets.hubShieldCam,
    ),
    HubModule(
      id: HubModuleId.clubDescuentos,
      title: 'Club de descuentos',
      subtitle: 'Restaurantes, tiendas y retail',
      svgAsset: AppAssets.hubDescuento,
      isNew: true,
    ),
    HubModule(
      id: HubModuleId.checkHealth,
      title: 'Check Health',
      subtitle: 'Revisa el estado de tu WIFI',
      svgAsset: AppAssets.hubCheckHealth,
      isHealth: true,
    ),
    HubModule(
      id: HubModuleId.mascotas,
      title: 'Mascotas',
      subtitle: 'Asistencia veterinaria por telefono',
      svgAsset: AppAssets.hubMascotas,
      isNew: true,
    ),
  ];
}

extension ModulosEntityX on ModulosEntity {
  bool? flagFor(HubModuleId id) => switch (id) {
        HubModuleId.eventos => eventos,
        HubModuleId.iptv => iptv,
        HubModuleId.vod => vod,
        HubModuleId.camaras => camaras,
        HubModuleId.clubDescuentos => clubDescuentos,
        HubModuleId.checkHealth => checkHealth,
        HubModuleId.mascotas => mascotas,
      };
}
