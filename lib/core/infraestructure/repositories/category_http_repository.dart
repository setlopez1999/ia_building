import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/domain/repositories/category_repository.dart';
import 'package:tvapp/core/infraestructure/dtos/login_dto/login_dto.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class CategoryHttpRepository implements CategoryRepository {
  @override
  Future<Either<AppException, List<Category>>> getCategories(String token) async {
    final Dio dio = Dio();
    final result = await dio.get(
      '${Environment.baseHost}/$token/inicio.json',
      options: Options(
        validateStatus: (status) => true,
      ),
    );

    if(result.statusCode != 200) {
      return left(
          AppException(
            statusCode: 3001,
            message: 'Error al obtener las categorías',
            identifier: 'Error'
          )
      );
    }

    final data = result.data as Map<String, dynamic>;

    if(data.containsKey('error') || (data.containsKey('code') && data['code'] == 400)) {
      return left(
          AppException(
            statusCode: 3001,
            message: 'Error al obtener las categorías',
            identifier: 'Error'
          )
      );
    }

    data['info']['devid'] = '';
    data['info']['token'] = '';

    final dto = LoginDto.fromJson(data);
    return Right(dto.categories);
  }
}