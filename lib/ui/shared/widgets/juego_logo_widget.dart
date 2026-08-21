import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// Caché en memoria: evita re-decodificar la misma logo (lista + detalle)
final _imageCache = <String, Uint8List>{};

// Top-level: parsea base64 con o sin prefijo data:image/...;base64,
Uint8List? decodeGameImage(String raw) {
  if (raw.isEmpty) return null;
  final cached = _imageCache[raw];
  if (cached != null) return cached;

  String b64 = raw.contains(',') ? raw.split(',').last : raw;
  b64 = b64.replaceAll(RegExp(r'\s'), '');
  final rem = b64.length % 4;
  if (rem != 0) b64 += '=' * (4 - rem);
  try {
    final bytes = base64Decode(b64);
    _imageCache[raw] = bytes;
    return bytes;
  } catch (_) {
    return null;
  }
}

class JuegoLogoWidget extends StatefulWidget {
  final String logo;
  final double size;

  const JuegoLogoWidget({super.key, required this.logo, this.size = 45});

  @override
  State<JuegoLogoWidget> createState() => _JuegoLogoWidgetState();
}

class _JuegoLogoWidgetState extends State<JuegoLogoWidget> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = decodeGameImage(widget.logo);
  }

  @override
  void didUpdateWidget(JuegoLogoWidget old) {
    super.didUpdateWidget(old);
    if (old.logo != widget.logo) {
      _bytes = decodeGameImage(widget.logo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    if (bytes == null) {
      return Icon(Icons.sports_esports, color: Colors.grey, size: widget.size * 0.7);
    }
    return Image.memory(
      bytes,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.sports_esports, color: Colors.grey, size: widget.size * 0.7),
    );
  }
}
