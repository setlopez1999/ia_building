import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/call/call_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

/// Módulo Mascotas: asistencia telefónica.
///
/// La pantalla solo pide la llamada; quién la origina lo decide
/// `callRepositoryProvider`. Hoy es [CallNoopRepository] y responde que el
/// servicio no está disponible, en vez de fingir que la llamada salió.
class MascotasScreen extends ConsumerWidget {
  const MascotasScreen({super.key});

  static String name = 'mascotas';
  static String path = '/mascotas';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(callProvider);
    final llamando = state is CallRequesting;

    // Regla 1: el resultado del pedido se ve siempre.
    ref.listen<CallState>(callProvider, (_, next) {
      if (next is CallFailed) {
        _mostrarMensaje(
          context,
          next.error.message,
          detalle: next.error.detail,
          esError: true,
        );
      } else if (next is CallRequested) {
        _mostrarMensaje(
          context,
          'Te estamos llamando. Atiende tu teléfono.',
          esError: false,
        );
      }
    });

    return Scaffold(
      appBar: customAppBar(context, title: 'Mascotas'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.pets, color: Colors.white24, size: 64),
              const SizedBox(height: 24),
              const Text(
                'Asistencia para tu mascota',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Un veterinario te llama para orientarte.\n'
                'Toca el botón y te contactamos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textBody, fontSize: 14),
              ),
              const Spacer(),
              _BotonLlamar(
                llamando: llamando,
                onPressed: () => ref.read(callProvider.notifier).requestCall(),
              ),
              const SizedBox(height: 20),
              Text(
                llamando
                    ? 'Solicitando la llamada...'
                    : 'La llamada es gratuita',
                style: const TextStyle(
                    color: AppColors.textBody, fontSize: 12),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarMensaje(
    BuildContext context,
    String mensaje, {
    String? detalle,
    required bool esError,
  }) {
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
}

/// Botón grande de llamada. Es la única acción de la pantalla, por eso ocupa
/// el lugar que ocupa.
class _BotonLlamar extends StatelessWidget {
  const _BotonLlamar({required this.llamando, required this.onPressed});

  final bool llamando;
  final VoidCallback onPressed;

  static const double _tamanio = 170;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Llamar a asistencia',
      child: GestureDetector(
        onTap: llamando ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _tamanio,
          height: _tamanio,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: llamando
                ? Environment.actionColor.withValues(alpha: 0.5)
                : Environment.actionColor,
            boxShadow: [
              BoxShadow(
                color: Environment.actionColor.withValues(alpha: 0.35),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          child: llamando
              ? const Center(
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 52),
                    SizedBox(height: 8),
                    Text(
                      'Llamar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
