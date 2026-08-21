import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/contact/contact_entity.dart';
import 'package:tvapp/core/domain/entities/login_info/login_info_entity.dart';
import 'package:tvapp/core/domain/entities/sensitive_data/sensitive_data_entity.dart';
import 'package:tvapp/core/domain/entities/settings/settings_entity.dart';
import 'package:tvapp/core/domain/entities/user/user_entity.dart';
import 'package:tvapp/core/domain/repositories/auth_repository.dart';
import 'package:tvapp/core/infraestructure/dtos/login_dto/login_dto.dart';
import 'package:tvapp/core/infraestructure/dtos/register_dto/register_user_dto.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class AuthHttpRepository implements AuthRepository {
  @override
  Future<Either<AppException, User>> login(
      String email, String password) async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final Dio dio = Dio();
    final loginData = {
      'usuario': email,
      'pass': password,
      'devid': '',
      'marca': '',
      'manufacturer': '',
      'modelo': '',
      'platform': 0,
    };

    if (Platform.isAndroid) {
      final androidID = await const AndroidId().getId();
      loginData['devid'] =
          androidID!.replaceAll('[^a-zA-Z0-9]', '').replaceAll('-', '');
      final device = await deviceInfoPlugin.androidInfo;

      loginData['marca'] = device.brand;
      loginData['manufacturer'] = device.manufacturer;
      loginData['modelo'] = device.model;
      loginData['platform'] = 1;
    }

    if (Platform.isIOS) {
      final device = await deviceInfoPlugin.iosInfo;
      loginData['marca'] = 'Apple';
      loginData['manufacturer'] = 'Apple Inc.';
      loginData['modelo'] = device.model;
      loginData['platform'] = 2;
      loginData['devid'] = device.identifierForVendor!.replaceAll('[^a-zA-Z0-9]', '').replaceAll('-', '').toLowerCase();
    }

    try {
      final response = await dio.post<Map<String, dynamic>>(
        '${Environment.baseHost}/api/inicio',
        data: loginData,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'User-Agent': Platform.isAndroid
                ? 'APPMOVIL-${loginData['devid']}'
                : 'APPMOVILIOS-${loginData['devid']}',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(AppException(
            identifier: 'Error iniciando sesión',
            message: response.statusMessage ?? 'Error desconocido',
            statusCode: 1000));
      }

      if (response.data?['code'] != 200) {
        return Left(AppException(
            identifier: 'Error iniciando sesión',
            message: response.data?['mensaje'] ?? 'Error desconocido',
            statusCode: 1001));
      }

      response.data!['info']['devid'] = loginData['devid'];

      final result = LoginDto.fromJson(response.data!);
      return Right(result.info);
    } on DioException catch (e) {
      return Left(AppException(
          identifier: 'Error iniciando sesión',
          message: e.message.toString(),
          statusCode: 1002));
    }
  }

  @override
  Future<Either<AppException, SensitiveDataEntity>> getSensitiveData() async {
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      final data = sharedPrefs.getString('data');

      if (data == null) {
        return Left(AppException(
          identifier: 'Error',
          message: 'No se pudo obtener la sesión',
          statusCode: 1005,
        ));
      }

      return Right(SensitiveDataEntity.fromJson(jsonDecode(data)));
    } catch (e) {
      return Left(AppException(
        identifier: 'Error',
        message: 'Ocurrió un error al leer la sesión',
        statusCode: 1006,
      ));
    }
  }

  @override
  Future<Either<AppException, bool>> saveSensitiveData(
      SensitiveDataEntity sensitiveDataEntity) async {
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      final success = await sharedPrefs.setString(
          'data', jsonEncode(sensitiveDataEntity.toJson()));
      if (!success) {
        throw Exception('No se pudo guardar la data en SharedPreferences');
      }

      await saveTokensInHistory(sensitiveDataEntity.token, sensitiveDataEntity.email);

      return const Right(true);
    } catch (e) {
      return Left(AppException(
        identifier: 'Error Iniciando sesión',
        message: 'No se pudo almacenar la sesión',
        statusCode: 1004,
      ));
    }
  }


  Future<void> saveTokensInHistory(String token, String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tokens = prefs.getStringList('tokens') ?? []
    ..add('$token|$email|${DateTime.now().toIso8601String()}');

    if(tokens.length > 5){
      tokens.removeAt(0);
    }

    await prefs.setStringList('tokens', tokens);
  }

  @override
  Future<Either<AppException, User>> loginWithToken(String token) async {
    try {
      final Dio dio = Dio();
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      String devid = '';

      if (Platform.isAndroid) {
        final androidID = await const AndroidId().getId();
        devid = androidID!.replaceAll('[^a-zA-Z0-9]', '').replaceAll('-', '');
      }

      if (Platform.isIOS) {
        final device = await deviceInfoPlugin.iosInfo;
        devid = device.identifierForVendor!.replaceAll('[^a-zA-Z0-9]', '').replaceAll('-', '').toLowerCase();
      }

      final result = await dio.get(
        '${Environment.baseHost}/$token/inicio.json',
      );

      if (result.statusCode == 404) {
        return left(AppException(
            statusCode: 1006,
            message: 'Error al recargar la sesión',
            identifier: 'Error'));
      }

      final data = result.data as Map<String, dynamic>;

      if (data.containsKey('error')) {
        return left(AppException(
            statusCode: 1007,
            message: 'Error al recargar la sesión',
            identifier: 'Error'));
      }
      data['info']['devid'] = devid;
      data['info']['token'] = token;
      final dto = LoginDto.fromJson(data);
      return Right(dto.info);
    } catch (e) {
      return left(AppException(
          statusCode: 1008,
          message: 'Error al recargar la sesión',
          identifier: 'Error'));
    }
  }

  @override
  Future<void> cleanSession() async {
    final sensitiveData = await getSensitiveData();

    await sensitiveData.fold(
          (error) async => null,
          (data) async {
        await unbind(data.token);

        final sharedPrefs = await SharedPreferences.getInstance();
        await sharedPrefs.remove('data');
      },
    );
  }


  @override
  Future<Either<AppException, void>> register({
    required Settings settings,
    required RegisterUserDto params,
    required String departmentCode,
    required String provinceCode,
    required String districtCode,
    required bool acceptTerms,
    required bool acceptPolicies
  }) async {

    await Future.delayed(const Duration(seconds: 2));
    return const Right(null);

    final Dio dio = Dio();
    final res = await dio.post<Map<String, dynamic>>(
      '${Environment.middlewareHost}/api/client/register',
      data: {
        'document_type_id': 1,
        'document_number': params.dni.toString(),
        'name': params.firstName.toString(),
        'first_lastname': params.lastName.split(' ').first,
        'second_lastname': params.lastName.split(' ').last,
        'phone': params.phoneNumber.toString(),
        'email': params.email.toString(),
        'plan_id': settings.planFreeSelected,  //1
        'ubigeo_code': '$departmentCode$provinceCode$districtCode',
        'accept_terms': acceptTerms,
        'accept_policies': acceptPolicies,
      },
    );
    final data = res.data;

    if (data!['result'] == true) {
      return const Right(null);
    }
    if (data['result'] == false) {
      return Left(
        AppException(
          identifier: '10003',
          message: data['mensaje'],
          statusCode: 500,
        ),
      );
    }

    return Left(
      AppException(
        identifier: '10004',
        message: 'Error registrando al usuario',
        statusCode: 500,
      ),
    );
  }

  Future<void> unbind(String token) async {
    final Dio dio = Dio();
    await dio.post('${Environment.baseHost}/api/desvincular', data: {
      'token': token,
    });
  }

  @override
  Future<Either<AppException, Contact>> getAuthInfo() async {
    try {
      final Dio dio = Dio();

      final result = await dio.get(
        '${Environment.baseHost}/api/get-contacts',
      );

      if (result.statusCode == 404) {
        return left(AppException(
            statusCode: 1006,
            message: 'Error al obtener contactos',
            identifier: 'Error'));
      }

      final data = result.data as Map<String, dynamic>;

      if (data.containsKey('error')) {
        return left(AppException(
            statusCode: 1007,
            message: 'Error al obtener contactos',
            identifier: 'Error'));
      }

      final dto = Contact.fromJson(data['data']);
      return Right(dto);
    } catch (e) {
      return left(AppException(
          statusCode: 1008,
          message: 'Error al obtener contactos',
          identifier: 'Error'));
    }
  }

}

