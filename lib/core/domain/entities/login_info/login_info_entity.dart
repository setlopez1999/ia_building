import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_info_entity.freezed.dart';
part 'login_info_entity.g.dart';

@freezed
abstract class LoginInfo with _$LoginInfo {
  const factory LoginInfo({
    required String api_url,
    required String background,
    required String colorB,
    required String colorF,
    required String colorI,
    required String correosoporte,
    required String fingerprint,
    required String fonosoporte,
    @Default('') String whatsapp,
    required String leyendapremium,
    required String logoprincipal,
    required String logosidebar,
    required String textoprincipal,
  }) = _LoginInfo;

  factory LoginInfo.fromJson(Map<String, dynamic> json) => _$LoginInfoFromJson(json);
}
