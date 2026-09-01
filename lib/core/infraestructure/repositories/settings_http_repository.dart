import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/domain/repositories/settings_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class SettingsHttpRepository implements SettingsRepository {
  /// Ver el comentario en [getSettings]. Hoy la fuente de los textos legales
  /// pertenece a otro operador.
  static const bool _textosLegalesConfiables = false;

  @override
  Future<Either<AppException, Settings>> getSettings() async {
    final dio = Dio();
    final response = await dio.get(
      '${Environment.middlewareHost}/api/config?key=register',
    );

    if (response.statusCode == 200) {
      final data = (response.data['data'] as List)[0];
      final details = data['details'];
      final terms = List.from(details.where((item) {
        return item['key'] == 'terms_and_conditions';
      }))[0]['value'];
      final policies = List.from(details.where((item) {
        return item['key'] == 'policies';
      }))[0]['value'];
      final planFreeSelected = List.from(details.where((item) {
        return item['key'] == 'plan_free_selected';
      }))[0]['value'];

      return Right(Settings(
          // ⚠️ Los textos legales que devuelve MIDDLEWARE_HOST son de BANTEL,
          // otro operador: dicen "BANTEL S.A.C." y "Bantel tv+". Mostrarlos
          // como propios de OnePlay es un problema legal, no estetico, asi que
          // se bloquean hasta que el backend entregue los correctos.
          //
          // Las pantallas ya manejan el caso vacio: muestran que el contenido
          // no esta disponible en vez de una pantalla en blanco.
          //
          // Para reactivarlos: poner [_textosLegalesConfiables] en true una vez
          // que MIDDLEWARE_HOST apunte al middleware de OnePlay.
          terms: _textosLegalesConfiables ? terms : '',
          policies: _textosLegalesConfiables ? policies : '',
          planFreeSelected: planFreeSelected
      ));
    }

    return Left(AppException(
      identifier: '10001',
      message: 'Error al obtener la configuración',
      statusCode: response.statusCode ?? 500,
    ));
  }

}