import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/ui/screens/main/main.screen.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

/// Confirmación de envío del nuevo código de Filtro Familiar.
///
/// ⚠️ PANTALLA OCULTA. La ruta existe (`/family-filter/code-sent`) pero
/// **ningún botón navega hasta acá todavía**: falta definir quién dispara el
/// envío del código y contra qué endpoint. Cuando exista, basta con navegar a
/// [FamilyFilterCodeSentScreen.name] después de la llamada exitosa.
class FamilyFilterCodeSentScreen extends ConsumerWidget {
  const FamilyFilterCodeSentScreen({super.key});

  static String name = 'family-filter-code-sent';
  static String path = '/family-filter/code-sent';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(context, title: 'Control Parental'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.iconSendMail,
                      width: 90,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 28),
                    const GoogleTextWidget(
                      'Le hemos enviado a su correo\nun nuevo código de Filtro Familiar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Environment.actionColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => context.goNamed(MainScreen.name),
                  child: const Text(
                    'Finalizar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
