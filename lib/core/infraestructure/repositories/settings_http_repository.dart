import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/domain/repositories/settings_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class SettingsHttpRepository implements SettingsRepository {
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
          terms: terms,
          policies: policies,
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