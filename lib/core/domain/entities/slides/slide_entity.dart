import 'package:freezed_annotation/freezed_annotation.dart';

part 'slide_entity.freezed.dart';
part 'slide_entity.g.dart';

@freezed
abstract class Slide with _$Slide {
  const factory Slide({
    required String imagen,
  }) = _Slide;

  const Slide._();

  factory Slide.fromJson(Map<String, dynamic> json) => _$SlideFromJson(json);
}