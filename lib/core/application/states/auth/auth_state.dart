import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvapp/core/domain/entities/user/user_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.error(AppException failure) = Error;
  const factory AuthState.success(User entity) = Success;
}