import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/screens/login/login.screen.dart';
import 'package:tvapp/ui/shared/widgets/google_text_span.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

/// Register Screen
class RegisterConfirmationScreen extends ConsumerStatefulWidget {
  const RegisterConfirmationScreen({super.key});

  static String name = 'register-confirmation';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterConfirmationScreen>{
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (booleaano) {
        booleaano = false;
        context.pushReplacementNamed(LoginScreen.name);
      },
      child: Scaffold(body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.secondaryColor(context),
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  const GoogleTextWidget(
                    'Confirmación de registro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const GoogleTextWidget(
                '¡Registro completado\ncon éxito!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/send_mail.png',
                      width: 70,
                      height: 70,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16,),
                    RichText(
                  textAlign: TextAlign.justify,
                  text: googleTextSpan(
                    context,
                    value: 'Revisa tu correo electrónico e inicia\nsesión con el usuario y contraseña\nque te hemos enviado.',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                        color: Colors.white,
                    ),))
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (context.mounted) {
                    context.pushReplacementNamed(LoginScreen.name);
                  }
                },
                child: const Text('Ir a Iniciar sesión', style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      )),
    );
  }
}
