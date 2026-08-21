import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

abstract class MultiCDNRepository {
  Future<Either<AppException, String>> getIP();
  Future<Either<AppException, String>> getURL(String ip);
}