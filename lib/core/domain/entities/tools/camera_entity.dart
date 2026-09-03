class CameraEntity {

  const CameraEntity({
    required this.id,
    this.serial = '',
    required this.name,
    this.isEvent = false,
    required this.srt,
    required this.hls,
    this.onvif = '',
    this.motionLogUrl = '',
    this.onvifApiUrl = '',
    this.ipCamara = '',
    this.usuario = '',
    this.passwordCamara = '',
    this.srtPuerto,
    this.fromLivePlayer = false,
  });

  factory CameraEntity.fromJson(Map<String, dynamic> json) {
    return CameraEntity(
      id: json['id'] as String,
      serial: json['serial'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isEvent: json['isEvent'] as bool? ?? false,
      srt: json['srt'] as String? ?? '',
      hls: json['hls'] as String? ?? '',
      onvif: json['onvif'] as String? ?? '',
      motionLogUrl: json['motionLogUrl'] as String? ?? '',
      onvifApiUrl: json['onvifApiUrl'] as String? ?? '',
      ipCamara: json['ipCamara'] as String? ?? '',
      usuario: json['usuario'] as String? ?? '',
      passwordCamara: json['passwordCamara'] as String? ?? '',
      srtPuerto: json['srtPuerto'] as String?,
    );
  }
  final String id;
  final String serial;
  final String name;
  final bool isEvent;
  final String srt;
  final String hls;
  final String onvif;
  final String motionLogUrl;
  final String onvifApiUrl;
  final String ipCamara;
  final String usuario;
  final String passwordCamara;
  final String? srtPuerto;
  final bool fromLivePlayer;

  CameraEntity copyWith({
    String? id,
    String? serial,
    String? name,
    bool? isEvent,
    String? srt,
    String? hls,
    String? onvif,
    String? motionLogUrl,
    String? onvifApiUrl,
    String? ipCamara,
    String? usuario,
    String? passwordCamara,
    String? srtPuerto,
    bool? fromLivePlayer,
  }) {
    return CameraEntity(
      id: id ?? this.id,
      serial: serial ?? this.serial,
      name: name ?? this.name,
      isEvent: isEvent ?? this.isEvent,
      srt: srt ?? this.srt,
      hls: hls ?? this.hls,
      onvif: onvif ?? this.onvif,
      motionLogUrl: motionLogUrl ?? this.motionLogUrl,
      onvifApiUrl: onvifApiUrl ?? this.onvifApiUrl,
      ipCamara: ipCamara ?? this.ipCamara,
      usuario: usuario ?? this.usuario,
      passwordCamara: passwordCamara ?? this.passwordCamara,
      srtPuerto: srtPuerto ?? this.srtPuerto,
      fromLivePlayer: fromLivePlayer ?? this.fromLivePlayer,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'serial': serial,
    'name': name,
    'isEvent': isEvent,
    'srt': srt,
    'hls': hls,
    'onvif': onvif,
    'motionLogUrl': motionLogUrl,
    'onvifApiUrl': onvifApiUrl,
    'ipCamara': ipCamara,
    'usuario': usuario,
    'passwordCamara': passwordCamara,
    'srtPuerto': srtPuerto,
  };
}
