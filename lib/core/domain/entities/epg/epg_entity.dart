import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tvapp/core/shared/converters/string_int.converter.dart';

part 'epg_entity.freezed.dart';
part 'epg_entity.g.dart';

@freezed
abstract class Epg with _$Epg {
  const factory Epg({
    required String anterior,
    required String desc,
    @StringIntConverter() required int fecha_fin,
    @StringIntConverter() required int fecha_ini,
    required int run,
    required String siguiente,
    required String titulo,
  }) = _Epg;

  factory Epg.fromJson(Map<String, dynamic> json) => _$EpgFromJson(json);
}