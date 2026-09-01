import 'package:flutter/material.dart';
import 'package:tvapp/config/environment/environment.dart';

/// Atenúa y vuelve a mostrar el contenido cuando cambia de canal, para que el
/// salto no sea un corte seco.
///
/// Se apaga entero con `CHANNEL_FADE_ENABLED=false` en el `.env`, y la
/// duración sale de `CHANNEL_FADE_MS`. Con el flag apagado el widget devuelve
/// el hijo tal cual, sin envolverlo en nada.
///
/// No reconstruye al hijo: solo cambia su opacidad. Reconstruirlo obligaría a
/// recrear el reproductor en cada cambio de canal.
class ChannelFade extends StatefulWidget {
  const ChannelFade({
    super.key,
    required this.channelKey,
    required this.child,
  });

  /// Valor que cambia cuando cambia el canal (por ejemplo su número).
  final Object? channelKey;

  final Widget child;

  @override
  State<ChannelFade> createState() => _ChannelFadeState();
}

class _ChannelFadeState extends State<ChannelFade> {
  double _opacity = 1;

  Duration get _duration =>
      Duration(milliseconds: Environment.channelFadeMs);

  @override
  void didUpdateWidget(covariant ChannelFade oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!Environment.channelFadeEnabled) return;
    if (oldWidget.channelKey == widget.channelKey) return;
    if (widget.channelKey == null) return;

    setState(() => _opacity = 0);
    Future.delayed(_duration, () {
      if (mounted) setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Environment.channelFadeEnabled) return widget.child;

    return AnimatedOpacity(
      opacity: _opacity,
      duration: _duration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}
