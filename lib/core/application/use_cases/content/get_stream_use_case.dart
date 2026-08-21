import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/entities/stream/stream_entity.dart';
import 'package:tvapp/core/domain/repositories/channels_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetStreamUseCase {
  GetStreamUseCase(this._channelsRepository);
  final ChannelsRepository _channelsRepository;

  Future<Either<AppException, StreamEntity>> execute(String token, Channel channel, String multiCdn) {
    return _channelsRepository.getStream(token, channel, multiCdn);
  }
}