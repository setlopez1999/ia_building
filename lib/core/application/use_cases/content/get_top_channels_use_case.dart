import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/repositories/top_channels_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetTopChannelsUseCase {
  GetTopChannelsUseCase(this._channelsRepository);

  final TopChannelsRepository _channelsRepository;

  Future<Either<AppException, List<Channel>>> execute(String userId) {
    return _channelsRepository.getTopChannels(userId);
  }
}
