import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/repositories/top_channels_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class TopChannelsHttpRepository implements TopChannelsRepository {
  @override
  Future<Either<AppException, List<Channel>>> getTopChannels(
      String user_id) async {
    final Dio dio = Dio();
    final res = await dio.get('${Environment.baseHost}/api/mostwatched-channels?user_id=$user_id');

    final data = res.data!;

    if (data is Map && data.containsKey('code') && data['code'] == 400) {
      return Left(AppException(
          statusCode: 4001,
          message: 'Error al obtener los canales mas vistos',
          identifier: 'Error'));
    }

    final list = data.take(5).map<Channel>((dynamic item) => Channel.fromJson(item as Map<String, dynamic>));

    return Right(list.toList());
  }
}
