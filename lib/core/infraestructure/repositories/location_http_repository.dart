import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/location/location.entity.dart';
import 'package:tvapp/core/domain/repositories/location_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class LocationHttpRepository implements LocationRepository {
  @override
  Future<Either<AppException, List<LocationEntity>>> getDepartments() async {
    final List<LocationEntity> result = <LocationEntity>[];
    try {
      final Dio dio = Dio();
      final response = await dio.get(
        '${Environment.middlewareHost}/api/address/department',
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        for (final json in data) {
          result.add(LocationEntity.fromJson(json));
        }
      }
    } catch (error) {
      return Left(AppException(
        identifier: '9001',
        message: 'Error obteniendo departamentos',
        statusCode: 500,
      ));
    }
    return Right(result);
  }

  @override
  Future<Either<AppException, List<LocationEntity>>> getDistricts(String departmentCode, String provinceCode) async {
    final List<LocationEntity> result = <LocationEntity>[];
    try {
      final Dio dio = Dio();
      final response = await dio.get(
        '${Environment.middlewareHost}/api/address/district?department_code=$departmentCode&province_code=$provinceCode',
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        for (final json in data) {
          result.add(LocationEntity.fromJson(json));
        }
      }
    } on SocketException catch (error) {
      return Left(AppException(
        identifier: '9002',
        message: 'Error obteniendo distritos',
        statusCode: 500,
      ));    }
    return Right(result);
  }

  @override
  Future<Either<AppException, List<LocationEntity>>> getProvinces(String departmentCode) async {
    final List<LocationEntity> result = <LocationEntity>[];
    try {
      final Dio dio = Dio();
      final response = await dio.get(
        '${Environment.middlewareHost}/api/address/province?department_code=$departmentCode',
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        for (final json in data) {
          result.add(LocationEntity.fromJson(json));
        }
      }
    } catch (error) {
      return Left(AppException(
        identifier: '9003',
        message: 'Error obteniendo provincias',
        statusCode: 500,
      ));    }
    return Right(result);
  }

}