// To parse this JSON data, do
//
//     final loginDto = loginDtoFromJson(jsonString);
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/core/domain/entities/login_info/login_info_entity.dart';
import 'package:tvapp/core/domain/entities/user/user_entity.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@freezed
abstract class LoginDto with _$LoginDto {
  const factory LoginDto({
    required int code,
    required int fecha,
    required User info,
    @JsonKey(name: 'default')
    required LoginInfo loginInfo,
    @JsonKey(name:'googlevideos')
    required List<Category> categories,
    required List<int> premiumsallowed,
  }) = _Category;

  factory LoginDto.fromJson(Map<String, dynamic> json) => _$LoginDtoFromJson(json);
}
