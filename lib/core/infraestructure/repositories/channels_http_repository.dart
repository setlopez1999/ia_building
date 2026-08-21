import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/error_handler/domain_exception.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/core/domain/repositories/channels_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class ChannelsHttpRepository implements ChannelsRepository {
  @override
  Future<Either<AppException, List<Channel>>> getChannelsByCategory(String token, String id) async {
    final Dio dio = Dio();
    final res = await dio.get('${Environment.baseHost}/$token/st$id.json');

    final data = res.data!;

    if(res.statusCode != 200  || data is Map && data.containsKey('error') && data['error'] == 404) {
      return Left(AppException(
          statusCode: 3001,
          message: 'Error al obtener los canales',
          identifier: 'Error'));
    }


    if (data is! List) {
      return Left(AppException(
          statusCode: 4001,
          message: 'Error al obtener los canales',
          identifier: 'Error'));
    }

    final List<Channel> list = [];

    for (final item in data) {
      list.addAll(item['section']['videos']
          .map<Channel>((item) {
            if(!(item is Map && item.containsKey('category_id'))) {
              item['category_id'] = int.parse(id);
            }

            if(!(item is Map && item.containsKey('restriccion'))) {
              item['restriccion'] = 0;
            }

            return Channel.fromJson(item as Map<String, dynamic>);
          }));
    }
    list.sort((a, b) => a.number.compareTo(b.number));
    return Right(list.toList());
  }

  @override
  Future<Either<AppException, List<Channel>>> getAllChannels(String token) async {
    final Dio dio = Dio();
    final res = await dio.get('${Environment.baseHost}/$token/0.json');

    final data = res.data!;

    if(
      res.statusCode != 200  ||
      (data is Map && data.containsKey('error') && data['error'] == 404) ||
      data is! List
    ) {
      return Left(AppException(
          statusCode: 3001,
          message: 'Error al obtener los canales',
          identifier: 'Error'));
    }


    final list = data
        .map<Channel>((item) => Channel.fromJson(item as Map<String, dynamic>))
        .toList()
        ..sort((a, b) => a.number.compareTo(b.number));
    return Right(list.toList());
  }

  @override
  Future<Either<AppException, List<Channel>>> getFavorites(String email) async {
    final Dio dio = Dio();
    final res = await dio.post('${Environment.baseHost}/api/get-favorite?user_email=$email');

    final data = res.data!;

    if (data is! Map) {
      return Left(AppException(
          statusCode: 4001,
          message: 'Error al obtener los canales favoritos',
          identifier: 'Error'));
    }

    final list = data['channels']
        .map<Channel>((item) {

      item['card'] = item['imagen'];
      item['number'] = item['numero'];
      item['description'] = item['descripcion'];
      item['studio'] = item['cn_id'];
      item['title'] = item['nombre'];
      item['epg'] = [];

      return Channel.fromJson(item as Map<String, dynamic>);

    }).toList();
    (list as List<Channel>).sort((a, b) => a.number.compareTo(b.number));
    return Right(list.toList());
  }

  @override
  Future<Either<AppException, void>> setFavorite(Channel channel, String email) async  {
    try {
      final Dio dio = Dio();

      await dio.post(
        '${Environment.baseHost}/api/set-favorite',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }),
        data: jsonEncode(
          {
            'user_email': email,
            'channel_id': channel.studio,
          },
        ),
      );
      return const Right(null);
    }catch (e) {
      return Left(AppException(
          statusCode: 4001,
          message: 'Error al agregar el canal favorito',
          identifier: 'Error'));
    }
  }

  @override
  Future<Either<AppException, void>> deleteFavorite(Channel channel, String email) async {
    try {
      final Dio dio = Dio();

      await dio.post(
        '${Environment.baseHost}/api/delete-favorite',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }),
        data: jsonEncode(
          {
            'user_email': email,
            'channel_id': channel.studio,
          },
        ),
      );

      return const Right(null);
    }catch (e) {
      return Left(AppException(
          statusCode: 4001,
          message: 'Error al eliminar el canal favorito',
          identifier: 'Error'));
    }
  }

  @override
  Future<Either<AppException, StreamEntity>> getStream(String token, Channel channel, String multiCDN) async {
    final Dio dio = Dio();
    final res = await dio.get('${Environment.baseHost}/$token/${channel.studio}.json');

    final data = res.data!;

    if (data is! Map) {
      return Left(AppException(
          statusCode: 4001,
          message: 'Error al obtener los canales',
          identifier: 'Error'));
    }

    if(data.containsKey('error') && data['error'] == 404) {
      throw DomainException(message: 'Sessión cerrada');
    }

    if (multiCDN.isNotEmpty) {
      //modificamos el link movil con la url del multicdn
      data['linkMovil'] = multiCDN + data['channelMovil'];
    }

    data['channel'] = channel.toJson();

    return Right(StreamEntity.fromJson(data as Map<String, dynamic>));
  }

}