import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/repositories/channels_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetChannelsByCategoryUseCase {
  GetChannelsByCategoryUseCase(this._channelsRepository);
  final ChannelsRepository _channelsRepository;

  Future<Either<AppException, List<Channel>>> execute(String token, String id) {
    return _channelsRepository.getChannelsByCategory(token, id);
  }
}