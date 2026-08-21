import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class ChannelsRepository {
  Future<Either<AppException, List<Channel>>> getChannelsByCategory(String token, String id);
  Future<Either<AppException, List<Channel>>> getAllChannels(String token);
  Future<Either<AppException, List<Channel>>> getFavorites(String email);
  Future<Either<AppException, void>> setFavorite(Channel channel, String email);
  Future<Either<AppException, void>> deleteFavorite(Channel channel, String email);
  Future<Either<AppException, StreamEntity>> getStream(String token, Channel channel, String multiCDN);
}