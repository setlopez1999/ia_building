
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_user_dto.freezed.dart';
part 'register_user_dto.g.dart';

@freezed
abstract class RegisterUserDto with _$RegisterUserDto {
  const factory RegisterUserDto({
    required String firstName,
    required String lastName,
    required String dni,
    required String phoneNumber,
    required String email,
  }) = _RegisterUserDto;

  factory RegisterUserDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserDtoFromJson(json);
}