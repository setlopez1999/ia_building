import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/repositories/guide_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GuideHttpRepository implements GuideRepository {
  @override
  Future<Either<AppException, List<Channel>>> getGuide(String email) async {
    final Dio dio = Dio();
    final res = await dio.post('${Environment.baseHost}/api/get-epgguide?user=$email');

    final data = res.data!;

    if (data is! List) {
      return Left(AppException(
          statusCode: 4001,
          message: 'Error al obtener la guia',
          identifier: 'Error'));
    }

    final list = data
        .map<Channel>((item) {

          item['card'] = item['imagen'].toString();
          item['number'] = item['numero'];
          item['description'] = item['descripcion'].toString();
          item['studio'] = item['cn_id'];
          item['title'] = item['nombre'].toString();

      return Channel.fromJson(item as Map<String, dynamic>);
    });

    return Right(list.toList());
  }

}