// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostico.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiagnosticoImpl _$$DiagnosticoImplFromJson(Map<String, dynamic> json) =>
    _$DiagnosticoImpl(
      id: json['id'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      latenciaIspMs: (json['latenciaIspMs'] as num).toInt(),
      velocidadBajadaMbps: (json['velocidadBajadaMbps'] as num).toDouble(),
      resultado: json['resultado'] as String,
    );

Map<String, dynamic> _$$DiagnosticoImplToJson(_$DiagnosticoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fecha': instance.fecha.toIso8601String(),
      'latenciaIspMs': instance.latenciaIspMs,
      'velocidadBajadaMbps': instance.velocidadBajadaMbps,
      'resultado': instance.resultado,
    };

_$DiagnosticoRequestImpl _$$DiagnosticoRequestImplFromJson(
  Map<String, dynamic> json,
) => _$DiagnosticoRequestImpl(
  clienteId: json['clienteId'] as String,
  latenciaGoogleMs: (json['latenciaGoogleMs'] as num).toInt(),
  latenciaIspMs: (json['latenciaIspMs'] as num).toInt(),
  velocidadBajadaMbps: (json['velocidadBajadaMbps'] as num).toDouble(),
  velocidadSubidaMbps: (json['velocidadSubidaMbps'] as num).toDouble(),
  fibraPotenciaDbm: json['fibraPotenciaDbm'] as String,
  fibraEstado: json['fibraEstado'] as String,
);

Map<String, dynamic> _$$DiagnosticoRequestImplToJson(
  _$DiagnosticoRequestImpl instance,
) => <String, dynamic>{
  'clienteId': instance.clienteId,
  'latenciaGoogleMs': instance.latenciaGoogleMs,
  'latenciaIspMs': instance.latenciaIspMs,
  'velocidadBajadaMbps': instance.velocidadBajadaMbps,
  'velocidadSubidaMbps': instance.velocidadSubidaMbps,
  'fibraPotenciaDbm': instance.fibraPotenciaDbm,
  'fibraEstado': instance.fibraEstado,
};

_$DiagnosticoSaveResultImpl _$$DiagnosticoSaveResultImplFromJson(
  Map<String, dynamic> json,
) => _$DiagnosticoSaveResultImpl(
  success: json['success'] as bool,
  diagnosticoId: json['diagnosticoId'] as String,
  resultado: json['resultado'] as String,
);

Map<String, dynamic> _$$DiagnosticoSaveResultImplToJson(
  _$DiagnosticoSaveResultImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'diagnosticoId': instance.diagnosticoId,
  'resultado': instance.resultado,
};
