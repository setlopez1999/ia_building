import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tvapp/config/hub/hub_module_catalog.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/domain/interfaces/modulos/modulos_parser.dart';
import 'package:tvapp/core/infraestructure/parsers/modulos_parser_v1.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';

part 'hub_modules_provider.g.dart';

/// Punto de intercambio del parser: cuando cambie el formato real de la
/// API, solo se reemplaza esta instancia (p.ej. ModulosParserV2).
@Riverpod(keepAlive: true)
ModulosParser modulosParser(Ref ref) => const ModulosParserV1();

/// Módulos del hub visibles para el usuario actual.
///
/// - Debug ([HubModuleCatalog.showAll]): devuelve TODOS los módulos.
/// - Release: solo los que el backend marcó `true` en `info.modulos`.
///   Sin flags → lista vacía (ningún módulo).
@Riverpod(keepAlive: true)
List<HubModule> hubModules(Ref ref) {
  if (HubModuleCatalog.showAll) return HubModuleCatalog.all;

  final user = ref.watch(authProvider).maybeWhen(success: (u) => u, orElse: () => null);
  if (user == null) return const [];

  final flags = ref.watch(modulosParserProvider).parse(user.modulos ?? const {});
  if (flags == null) return const [];

  return HubModuleCatalog.all
      .where((m) => flags.flagFor(m.id) == true)
      .toList(growable: false);
}
