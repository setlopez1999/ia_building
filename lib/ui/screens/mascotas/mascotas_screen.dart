import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/call/call_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

/// Módulo Mascotas: asistencia telefónica.
///
/// La pantalla solo pide la llamada; quién la origina lo decide
/// `callRepositoryProvider`. Cambiar de central (hoy Asterisk de pruebas,
/// mañana el VICIdial del cliente) no toca esta pantalla.
///
/// Estructura, pensada para que crezca sin rehacerla:
///
/// ```
/// ┌──────────────────────────┐
/// │ encabezado (fijo arriba) │
/// ├──────────────────────────┤
/// │                          │
/// │   BOTÓN LLAMAR (centro)  │  ← ocupa el espacio libre y se centra solo
/// │   estado de la llamada   │
/// │                          │
/// ├──────────────────────────┤
/// │ acciones secundarias     │  ← hoy vacío; ver [_accionesSecundarias]
/// └──────────────────────────┘
/// ```
class MascotasScreen extends ConsumerWidget {
  const MascotasScreen({super.key});

  static String name = 'mascotas';
  static String path = '/mascotas';

  /// Botones chicos que acompañan al de llamar.
  ///
  /// Hoy la lista está vacía a propósito: la única acción del módulo es
  /// llamar, y la Regla 4 prohíbe mostrar botones que no hacen nada.
  ///
  /// Para sumar uno (p. ej. "Historial" o "Chat"), se agrega una entrada acá
  /// y la fila se acomoda sola — no hay que tocar el layout ni el botón
  /// grande, que se recentra en el espacio que queda.
  static const List<_AccionMascotas> _accionesSecundarias = [];

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
        // Sin el scroll, en pantallas bajas (o en horizontal) el botón de
        // 170 px más los textos desbordan el Column.
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: Column(
                  children: [
                    const _Encabezado(),
                    // El botón vive en el espacio sobrante y queda centrado
                    // en los dos ejes, sin depender de Spacers a mano.
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _BotonLlamar(
                              llamando: llamando,
                              onPressed: () =>
                                  ref.read(callProvider.notifier).requestCall(),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              llamando
                                  ? 'Solicitando la llamada...'
                                  : 'La llamada es gratuita',
                              style: const TextStyle(
                                color: AppColors.textBody,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const _AccionesSecundarias(_accionesSecundarias),
                  ],
                ),
              ),
            ),
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

/// Título del módulo. Fijo arriba para que el botón no se mueva de lugar
/// cuando el texto cambie.
class _Encabezado extends StatelessWidget {
  const _Encabezado();

  @override
  Widget build(BuildContext context) {
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
        const Text(
          'Asistencia para tu mascota',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Un veterinario te llama para orientarte.\n'
          'Toca el botón y te contactamos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textBody, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}

/// Una acción secundaria del módulo: ícono + etiqueta.
///
/// `onPressed` en `null` deja el botón deshabilitado (gris, sin tap).
class _AccionMascotas {
  const _AccionMascotas({
    required this.icono,
    required this.etiqueta,
    // El analizador avisa que nadie lo pasa: es cierto, porque
    // [MascotasScreen._accionesSecundarias] está vacía. El parámetro existe
    // justamente para la primera acción que se agregue.
    // ignore: unused_element_parameter
    this.onPressed,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback? onPressed;
}

/// Fila de acciones secundarias, debajo del botón de llamar.
///
/// Con la lista vacía no ocupa nada: la pantalla se ve igual que antes de
/// existir esta banda.
class _AccionesSecundarias extends StatelessWidget {
  const _AccionesSecundarias(this.acciones);

  final List<_AccionMascotas> acciones;

  @override
  Widget build(BuildContext context) {
    if (acciones.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          for (final accion in acciones) _BotonSecundario(accion),
        ],
      ),
    );
  }
}

class _BotonSecundario extends StatelessWidget {
  const _BotonSecundario(this.accion);

  final _AccionMascotas accion;

  @override
  Widget build(BuildContext context) {
    final habilitado = accion.onPressed != null;
    final color = habilitado ? Colors.white : Colors.white38;

    return Semantics(
      button: true,
      enabled: habilitado,
      label: accion.etiqueta,
      child: InkWell(
        onTap: accion.onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 104,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.container,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(accion.icono, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                accion.etiqueta,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón grande de llamada. Es la acción principal de la pantalla, por eso
/// ocupa el lugar que ocupa y va al centro.
class _BotonLlamar extends StatelessWidget {
  const _BotonLlamar({required this.llamando, required this.onPressed});

  final bool llamando;
  final VoidCallback onPressed;

  static const double _tamanio = 170;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: !llamando,
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
