import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tvapp/core/domain/entities/contact/contact_entity.dart';
import 'package:tvapp/core/shared/exceptions/app_exception.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/shared/widgets/api_state.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

/// Cuerpo compartido de "Cambiar contraseña" y "Control Parental": ambas
/// muestran los mismos datos de soporte y solo cambian el ícono y el texto.
///
/// Los contactos vienen dentro de la respuesta del login (bloque `default`
/// de `inicio.json`), no de un endpoint aparte.
class SupportContactBody extends ConsumerStatefulWidget {
  const SupportContactBody({
    super.key,
    required this.iconAsset,
    required this.message,
  });

  final String iconAsset;
  final String message;

  @override
  ConsumerState<SupportContactBody> createState() => _SupportContactBodyState();
}

class _SupportContactBodyState extends ConsumerState<SupportContactBody> {
  late Future<Either<AppException, Contact>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(authProvider.notifier).getLoginInfo();
  }

  Future<void> _reload() async {
    setState(() {
      _future = ref.read(authProvider.notifier).getLoginInfo();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<AppException, Contact>>(
      future: _future,
      builder: (context, snapshot) {
        // Regla 1: cargando, error y éxito, los tres visibles.
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return ApiErrorView(
            failure: AppException(
              identifier: 'Contacto',
              message: 'No se pudieron cargar los datos de contacto.',
              statusCode: 0,
            ),
            rawDetail: snapshot.error?.toString(),
            onRetry: _reload,
          );
        }

        return snapshot.data!.fold(
          // Antes esto era un SizedBox.shrink(): la pantalla quedaba en blanco
          // y el usuario no sabía a quién contactar ni por qué.
          (failure) => ApiErrorView(failure: failure, onRetry: _reload),
          (contact) => _Content(
            iconAsset: widget.iconAsset,
            message: widget.message,
            contact: contact,
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.iconAsset,
    required this.message,
    required this.contact,
  });

  final String iconAsset;
  final String message;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final whatsapp = contact.whatsapp.trim();
    final callCenter = contact.fonosoporte.trim();
    final correo = contact.correosoporte.trim();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconAsset, width: 100),
            const SizedBox(height: 32),
            GoogleTextWidget(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // Solo se muestra el canal que el servidor realmente envió.
            if (whatsapp.isNotEmpty)
              GoogleTextWidget('Whatsapp: $whatsapp', textAlign: TextAlign.center),
            if (callCenter.isNotEmpty)
              GoogleTextWidget('Call Center: $callCenter',
                  textAlign: TextAlign.center),
            if (correo.isNotEmpty)
              GoogleTextWidget('Correo: $correo', textAlign: TextAlign.center),
            if (whatsapp.isEmpty && callCenter.isEmpty && correo.isEmpty)
              const GoogleTextWidget(
                'No hay datos de contacto disponibles.',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
