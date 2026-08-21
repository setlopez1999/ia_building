import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fpdart/src/either.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/repositories/multicdn_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class MultiCDNHttpRepository implements MultiCDNRepository {
  @override
  Future<Either<AppException, String>> getIP() async {
    try {
      final Dio dio = Dio();

      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.get(Environment.ipFindHost);

      if(response.statusCode != 200) {
        print('Error obteniendo IP: status code: ${response.statusCode}');
        return Left(AppException(
          identifier: '5001',
          message: 'Error obteniendo IP',
          statusCode: response.statusCode ?? 500,
        ));
      }
      return Right(response.data['ip']);
    }
    catch (error) {
      print('Error obteniendo IP: General: ');
      print(error);
      return Left(AppException(
        identifier: '5001',
        message: 'Error obteniendo IP_',
        statusCode: 500,
      ));
    }
  }

  @override
  Future<Either<AppException, String>> getURL(String ip) async {
    try {
      final Dio dio = Dio();
      final response = await dio.post(
        '${Environment.baseHost}/api/get-ipurl',
        data: {
          'deviceid' : 2,
          'networkid': ip
        }
      );

      if(response.statusCode != 200) {
        print('Error Obteniendo URL: status code: ${response.statusCode}');
        return Left(AppException(
          identifier: '5001',
          message: 'Error obteniendo IP',
          statusCode: response.statusCode ?? 500,
        ));
      }

      final decoded = response.data as Map<String, dynamic>;

      if(decoded.containsKey('error') && decoded['error']) {
        print('Error Obteniendo URL: data: ${response.data}');

        return Left(AppException(
          identifier: '5001',
          message: decoded['message'],
          statusCode: response.statusCode ?? 500,
        ));
      }

      if(decoded['link'] == null) {
        print('Error Obteniendo URL: data: ${response.data}');
        return Left(AppException(
          identifier: '5001',
          message: decoded['message'],
          statusCode: response.statusCode ?? 500,
        ));
      }

      return Right(decoded['link']);
    }
    catch (error) {
      print('Error Obteniendo URL: General: ');
      print(error);
      return Left(AppException(
        identifier: '5001',
        message: 'Error obteniendo IP_',
        statusCode: 500,
      ));
    }
  }

}