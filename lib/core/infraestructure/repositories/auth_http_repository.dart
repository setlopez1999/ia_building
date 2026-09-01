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

      // El servidor puede responder 200 sin el bloque 'info' esperado; sin esta
      // guarda el acceso de abajo lanza y deja el login colgado.
      final info = response.data?['info'];
      if (info is! Map) {
        return Left(AppException(
            identifier: 'Error iniciando sesión',
            message: 'El servidor respondió de forma inesperada. Intenta nuevamente.',
            statusCode: 1003));
      }

      info['devid'] = loginData['devid'];

      final result = LoginDto.fromJson(response.data!);
      return Right(result.info);
    } on DioException catch (e) {
      return Left(AppException(
          identifier: 'Error iniciando sesión',
          message: _connectionMessage(e),
          statusCode: 1002));
    } catch (_) {
      return Left(AppException(
          identifier: 'Error iniciando sesión',
          message: 'El servidor respondió de forma inesperada. Intenta nuevamente.',
          statusCode: 1003));
    }
  }

  /// Traduce el error crudo de Dio a un mensaje que se pueda mostrar al usuario.
  String _connectionMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardó demasiado en responder. Verifica tu conexión e intenta nuevamente.';
      case DioExceptionType.connectionError:
        return 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
      case DioExceptionType.badResponse:
        return 'El servidor no está disponible en este momento. Intenta nuevamente.';
      case DioExceptionType.cancel:
        return 'La solicitud fue cancelada.';
      default:
        return 'Error de conexión. Intenta nuevamente.';
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


  /// ⚠️ PUNTO ÚNICO DE INTEGRACIÓN DEL REGISTRO.
  ///
  /// Hoy el registro **no crea ningún usuario**: espera 2 segundos y finge que
  /// salió bien, así que la app muestra "¡Registro completado!" sin que exista
  /// nada del otro lado. Además, el POST de abajo apunta al middleware de
  /// **Bantel** (`MIDDLEWARE_HOST`), no al de OnePlay.
  ///
  /// Para conectar el registro real:
  ///   1. Poner [_registroSimulado] en `false`.
  ///   2. Apuntar `MIDDLEWARE_HOST` del `.env` al servidor correcto.
  ///   3. Ajustar el payload del POST al contrato que entregue el backend.
  ///   4. Encender `REGISTER_ENABLED=true` en el `.env`.
  ///
  /// No hay ningún otro lugar del código que haya que tocar.
  static const bool _registroSimulado = true;

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
    if (_registroSimulado) {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(null);
    }

    try {
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
          'plan_id': settings.planFreeSelected,
          'ubigeo_code': '$departmentCode$provinceCode$districtCode',
          'accept_terms': acceptTerms,
          'accept_policies': acceptPolicies,
        },
        options: Options(validateStatus: (status) => true),
      );

      final data = res.data;

      if (res.statusCode == 200 && data?['result'] == true) {
        return const Right(null);
      }

      return Left(AppException(
        identifier: 'Registro',
        message: _mensajeRegistro(res.statusCode, data),
        statusCode: res.statusCode ?? 0,
        // Regla 1.b: solo se muestra con APP_DEBUG_MODE=true.
        detail: 'POST /api/client/register\n'
            'HTTP ${res.statusCode}\n'
            '${jsonEncode(data)}',
      ));
    } on DioException catch (e) {
      return Left(AppException(
        identifier: 'Registro',
        message: _connectionMessage(e),
        statusCode: 1002,
        detail: '${e.type}\n${e.message}\n${e.response?.data}',
      ));
    } catch (e) {
      return Left(AppException(
        identifier: 'Registro',
        message: 'No se pudo completar el registro. Intenta nuevamente.',
        statusCode: 1003,
        detail: e.toString(),
      ));
    }
  }

  /// Prioriza el motivo que devuelve el backend (por ejemplo "el correo ya
  /// está registrado"). Solo si no manda nada usable se cae a un mensaje
  /// genérico segun el codigo HTTP.
  String _mensajeRegistro(int? statusCode, Map<String, dynamic>? data) {
    final delServidor = (data?['mensaje'] ?? data?['message'])?.toString().trim();
    if (delServidor != null && delServidor.isNotEmpty) {
      return delServidor;
    }

    switch (statusCode) {
      case 409:
        return 'Ese correo o documento ya está registrado. '
            'Inicia sesión o usa otros datos.';
      case 400:
      case 422:
        return 'Revisa los datos ingresados: alguno no es válido.';
      case 401:
      case 403:
        return 'No tienes permiso para completar el registro.';
      case 404:
        return 'El servicio de registro no está disponible.';
      default:
        return 'No se pudo completar el registro. Intenta nuevamente.';
    }
  }

  Future<void> unbind(String token) async {
    final Dio dio = Dio();
    await dio.post('${Environment.baseHost}/api/desvincular', data: {
      'token': token,
    });
  }

  @override
  /// Datos de soporte (whatsapp, call center, correo) en cascada:
  ///
  ///   1. `GET /api/get-contacts` — la fuente oficial.
  ///   2. Si no responde o viene vacía, el bloque `default` de `inicio.json`,
  ///      que ya llega con la sesión.
  ///   3. Si ninguna de las dos trae nada, se informa que no hay contactos.
  ///
  /// El endpoint del punto 1 hoy responde `{"error":404}` en el servidor de
  /// OnePlay; por eso en la práctica manda la sesión.
  Future<Either<AppException, Contact>> getAuthInfo() async {
    final detalle = StringBuffer();

    final porApi = await _contactosDesdeApi(detalle);
    if (porApi != null) return Right(porApi);

    final porSesion = await _contactosDesdeSesion(detalle);
    if (porSesion != null) return Right(porSesion);

    return left(AppException(
      statusCode: 1008,
      message: 'No hay datos de contacto disponibles.',
      identifier: 'Contacto',
      detail: detalle.toString(),
    ));
  }

  /// Fuente 1: endpoint dedicado.
  Future<Contact?> _contactosDesdeApi(StringBuffer detalle) async {
    try {
      final Dio dio = Dio();
      final result = await dio.get(
        '${Environment.baseHost}/api/get-contacts',
        options: Options(validateStatus: (status) => true),
      );

      final data = result.data;
      detalle.writeln('[1] GET /api/get-contacts → HTTP ${result.statusCode}');
      detalle.writeln(jsonEncode(data));

      if (result.statusCode != 200 || data is! Map) return null;
      if (data.containsKey('error') || data['data'] is! Map) return null;

      final contact =
          Contact.fromJson(Map<String, dynamic>.from(data['data'] as Map));
      return _tieneAlgo(contact) ? contact : null;
    } catch (e) {
      detalle.writeln('[1] GET /api/get-contacts → $e');
      return null;
    }
  }

  /// Fuente 2: bloque `default` de la sesión.
  Future<Contact?> _contactosDesdeSesion(StringBuffer detalle) async {
    try {
      final session = await getSensitiveData();
      final token = session
          .getOrElse((_) => const SensitiveDataEntity(
                parental: '',
                token: '',
                email: '',
                userID: '',
                deviceId: '',
              ))
          .token;

      if (token.isEmpty) {
        detalle.writeln('[2] sesión sin token');
        return null;
      }

      final Dio dio = Dio();
      final result = await dio.get(
        '${Environment.baseHost}/$token/inicio.json',
        options: Options(validateStatus: (status) => true),
      );

      final data = result.data;
      detalle.writeln('[2] GET /{token}/inicio.json → HTTP ${result.statusCode}');

      if (result.statusCode != 200 || data is! Map) return null;
      if (data.containsKey('error') || data['default'] is! Map) return null;

      final contact =
          Contact.fromJson(Map<String, dynamic>.from(data['default'] as Map));
      return _tieneAlgo(contact) ? contact : null;
    } catch (e) {
      detalle.writeln('[2] inicio.json → $e');
      return null;
    }
  }

  /// Una respuesta con los tres campos vacíos no cuenta como encontrada:
  /// si no, la cascada se cortaría en el primer paso sin datos útiles.
  bool _tieneAlgo(Contact c) =>
      c.whatsapp.trim().isNotEmpty ||
      c.fonosoporte.trim().isNotEmpty ||
      c.correosoporte.trim().isNotEmpty;

}

