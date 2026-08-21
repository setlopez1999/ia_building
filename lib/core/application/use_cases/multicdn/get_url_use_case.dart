import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/repositories/multicdn_repository.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

class GetURLUseCase {
  GetURLUseCase(this._repository);

  final MultiCDNRepository _repository;

  Future<Either<AppException, String>> execute() async {
    final ip = await _repository.getIP();

    if(ip.isLeft()){
      return ip;
    }

    final ipValue = ip.getRight().getOrElse(() => '');

    final url = await _repository.getURL(ipValue);

    if(url.isLeft()){
      return url;
    }

    return url;
  }
}