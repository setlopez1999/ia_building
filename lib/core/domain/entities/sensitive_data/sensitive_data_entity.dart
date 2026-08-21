import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensitive_data_entity.freezed.dart';
part 'sensitive_data_entity.g.dart';

@freezed
abstract class SensitiveDataEntity with _$SensitiveDataEntity {
  const factory SensitiveDataEntity({
    required String token,
    required String parental,
    required String email,
    required String userID,
    required String deviceId,
  }) = _SensitiveDataEntity;

  factory SensitiveDataEntity.fromJson(Map<String, dynamic> json) =>
      _$SensitiveDataEntityFromJson(json);
}