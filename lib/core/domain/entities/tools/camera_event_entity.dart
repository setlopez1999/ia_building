class CameraEventEntity {

  const CameraEventEntity({
    required this.tipo,
    required this.unix,
    required this.utc,
    this.video = '',
    this.duracion = 0,
    this.ip = '',
    this.serial = '',
  });

  factory CameraEventEntity.fromJson(Map<String, dynamic> json) {
    return CameraEventEntity(
      tipo: json['tipo'] as String? ?? '',
      unix: json['unix'] as int? ?? 0,
      utc: json['utc'] as String? ?? '',
      video: json['video'] as String? ?? '',
      duracion: json['duracion'] as int? ?? 0,
      ip: json['ip'] as String? ?? '',
      serial: json['serial'] as String? ?? '',
    );
  }
  final String tipo;
  final int unix;
  final String utc;
  final String video;
  final int duracion;
  final String ip;
  final String serial;

  Map<String, dynamic> toJson() => {
    'tipo': tipo,
    'unix': unix,
    'utc': utc,
    'video': video,
    'duracion': duracion,
    'ip': ip,
    'serial': serial,
  };
}
