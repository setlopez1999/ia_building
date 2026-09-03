import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/domain/entities/call/call_session_state.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/call/call_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

/// Módulo Mascotas: asistencia veterinaria por teléfono.
///
/// El celular es un extremo real de la llamada, así que la pantalla puede
/// mostrar si atendieron, cuánto lleva la llamada, y cortar o silenciar.
/// Contra qué central se habla lo decide `callRepositoryProvider`.
class MascotasScreen extends ConsumerStatefulWidget {
  const MascotasScreen({super.key});

  static String name = 'mascotas';
  static String path = '/mascotas';

  @override
  ConsumerState<MascotasScreen> createState() => _MascotasScreenState();
}

class _MascotasScreenState extends ConsumerState<MascotasScreen> {
  @override
  void initState() {
    super.initState();
    // Registrarse al abrir la pantalla: cuando el usuario toque el botón, el
    // teléfono ya está listo y la llamada sale al toque.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callProvider.notifier).conectar();
    });
  }

  Future<void> _llamar() async {
    // Sin micrófono no hay llamada: se pide antes, no cuando ya está sonando.
    final permiso = await Permission.microphone.request();
    if (!permiso.isGranted) {
      if (!mounted) return;
      _avisar(
        'Necesitamos el micrófono para hacer la llamada.',
        esError: true,
      );
      return;
    }
    await ref.read(callProvider.notifier).llamar();
  }

  void _avisar(String mensaje, {String? detalle, required bool esError}) {
    final mostrarDetalle = Environment.appDebugMode && detalle != null;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.container,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: mostrarDetalle ? 8 : 4),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    esError ? Icons.error_outline : Icons.phone_in_talk,
                    color: esError ? AppColors.error : Environment.actionColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      mensaje,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
              // Regla 1.b: el detalle tecnico solo en debug.
              if (mostrarDetalle) ...[
                const SizedBox(height: 8),
                Text(
                  detalle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(callProvider);

    // Regla 1: toda falla se ve. Los estados normales los dibuja la pantalla.
    ref.listen<CallSessionState>(callProvider, (anterior, actual) {
      if (actual is CallFallida) {
        _avisar(
          actual.error.message,
          detalle: actual.error.detail,
          esError: true,
        );
      }
    });

    return Scaffold(
      appBar: customAppBar(context, title: 'Mascotas'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              // Sin IntrinsicHeight el scroll le da altura infinita a la
              // Column y el Expanded de abajo no tiene contra que expandirse:
              // la pantalla sale en blanco.
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                  child: Column(
                    children: [
                      _Encabezado(estado: estado),
                      Expanded(
                        child: Center(child: _BotonPrincipal(estado: estado)),
                      ),
                      _Acciones(
                        estado: estado,
                        onLlamar: _llamar,
                        onContestar: () =>
                            ref.read(callProvider.notifier).contestar(),
                        onColgar: () =>
                            ref.read(callProvider.notifier).colgar(),
                        onSilenciar: (valor) =>
                            ref.read(callProvider.notifier).silenciar(valor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Encabezado ───────────────────────────────────────────────────────────────

/// Título del módulo y estado de la llamada en palabras.
class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.estado});

  final CallSessionState estado;

  ({String titulo, String bajada}) get _textos => switch (estado) {
        CallDesconectada() || CallRegistrando() => (
            titulo: 'Asistencia para tu mascota',
            bajada: 'Conectando con la central…',
          ),
        CallLista() => (
            titulo: 'Asistencia para tu mascota',
            bajada: 'Un veterinario te atiende por teléfono.\n'
                'Toca el botón para llamar.',
          ),
        CallSaliente() => (
            titulo: 'Llamando…',
            bajada: 'Esperando que atienda el veterinario.',
          ),
        CallEntrante(deQuien: final quien) => (
            titulo: 'Llamada entrante',
            bajada: quien,
          ),
        CallEnCurso() => (titulo: 'En llamada', bajada: 'Con el veterinario.'),
        CallFinalizada(motivo: final motivo) => (
            titulo: 'Llamada terminada',
            bajada: motivo,
          ),
        CallFallida(error: final error) => (
            titulo: 'No se pudo llamar',
            bajada: error.message,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final textos = _textos;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Environment.actionColor.withValues(alpha: 0.12),
          ),
          child: Icon(Icons.pets, color: Environment.actionColor, size: 36),
        ),
        const SizedBox(height: 20),
        Text(
          textos.titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          textos.bajada,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textBody,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ── Botón grande del centro ──────────────────────────────────────────────────

/// Círculo central. Cambia según el momento de la llamada: ícono en reposo,
/// spinner mientras suena, cronómetro cuando ya hablan.
class _BotonPrincipal extends StatelessWidget {
  const _BotonPrincipal({required this.estado});

  final CallSessionState estado;

  static const double _tamanio = 170;

  @override
  Widget build(BuildContext context) {
    final enCurso = estado is CallEnCurso;
    final sonando = estado is CallSaliente || estado is CallEntrante;
    final conectando = estado is CallRegistrando || estado is CallDesconectada;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: _tamanio,
      height: _tamanio,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: conectando
            ? AppColors.container
            : Environment.actionColor.withValues(alpha: sonando ? 0.55 : 1),
        boxShadow: conectando
            ? null
            : [
                BoxShadow(
                  color: Environment.actionColor.withValues(alpha: 0.35),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
      ),
      child: Center(child: _contenido(enCurso, sonando, conectando)),
    );
  }

  Widget _contenido(bool enCurso, bool sonando, bool conectando) {
    if (enCurso) {
      return _Cronometro(desde: (estado as CallEnCurso).desde);
    }
    if (sonando || conectando) {
      return const SizedBox(
        width: 42,
        height: 42,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
      );
    }
    return const Icon(Icons.phone, color: Colors.white, size: 62);
  }
}

/// Cuenta el tiempo desde que atendieron.
class _Cronometro extends StatefulWidget {
  const _Cronometro({required this.desde});

  final DateTime desde;

  @override
  State<_Cronometro> createState() => _CronometroState();
}

class _CronometroState extends State<_Cronometro> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segundos = DateTime.now().difference(widget.desde).inSeconds;
    final mm = (segundos ~/ 60).toString().padLeft(2, '0');
    final ss = (segundos % 60).toString().padLeft(2, '0');

    return Text(
      '$mm:$ss',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}

// ── Banda de acciones ────────────────────────────────────────────────────────

/// Los botones de abajo. Un solo lugar decide cuáles se ven en cada momento,
/// así no queda ninguno encendido después de colgar.
class _Acciones extends StatelessWidget {
  const _Acciones({
    required this.estado,
    required this.onLlamar,
    required this.onContestar,
    required this.onColgar,
    required this.onSilenciar,
  });

  final CallSessionState estado;
  final VoidCallback onLlamar;
  final VoidCallback onContestar;
  final VoidCallback onColgar;
  final void Function(bool valor) onSilenciar;

  @override
  Widget build(BuildContext context) {
    final acciones = switch (estado) {
      CallEntrante() => [
          _Accion(
            icono: Icons.call,
            etiqueta: 'Contestar',
            color: Environment.actionColor,
            onPressed: onContestar,
          ),
          _Accion(
            icono: Icons.call_end,
            etiqueta: 'Rechazar',
            color: AppColors.error,
            onPressed: onColgar,
          ),
        ],
      CallSaliente() => [
          _Accion(
            icono: Icons.call_end,
            etiqueta: 'Cancelar',
            color: AppColors.error,
            onPressed: onColgar,
          ),
        ],
      CallEnCurso(silenciado: final silenciado) => [
          _Accion(
            icono: silenciado ? Icons.mic_off : Icons.mic,
            etiqueta: silenciado ? 'Silenciado' : 'Silenciar',
            color: silenciado ? Environment.actionColor : null,
            onPressed: () => onSilenciar(!silenciado),
          ),
          _Accion(
            icono: Icons.call_end,
            etiqueta: 'Colgar',
            color: AppColors.error,
            onPressed: onColgar,
          ),
        ],
      CallLista() || CallFinalizada() || CallFallida() => [
          _Accion(
            icono: Icons.call,
            etiqueta: 'Llamar',
            color: Environment.actionColor,
            onPressed: onLlamar,
          ),
        ],
      // Mientras se registra no hay nada que ofrecer todavía.
      CallDesconectada() || CallRegistrando() => const <_Accion>[],
    };

    if (acciones.isEmpty) return const SizedBox(height: 24);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: acciones,
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  const _Accion({
    required this.icono,
    required this.etiqueta,
    required this.onPressed,
    this.color,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tinte = color ?? Colors.white;

    return Semantics(
      button: true,
      label: etiqueta,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 112,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.container,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tinte.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, color: tinte, size: 24),
              const SizedBox(height: 8),
              Text(
                etiqueta,
                textAlign: TextAlign.center,
                style: TextStyle(color: tinte, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
