class ChatResponseDto {
  final String? output;
  final String? error;

  ChatResponseDto({this.output, this.error});

  factory ChatResponseDto.fromJson(Map<String, dynamic> json) =>
      ChatResponseDto(
        output: json['output']?.toString(),
        error: json['error']?.toString(),
      );

  String resolve() => output ?? error ?? 'Sin respuesta';
}
