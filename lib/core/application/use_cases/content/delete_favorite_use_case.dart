import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/channel/channel_entity.dart';
import 'package:tvapp/core/domain/repositories/channels_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class DeleteFavoriteUseCase {

  DeleteFavoriteUseCase(this._channelsRepository);
  final ChannelsRepository _channelsRepository;

  Future<Either<AppException, void>> execute(Channel channel, String email)  {
    return _channelsRepository.deleteFavorite(channel, email);
  }
}