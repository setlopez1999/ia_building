import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class ChangePasswordScreen extends ConsumerWidget {
  const ChangePasswordScreen({super.key});

  static String name = 'Change password';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);

    return Scaffold(
        appBar: customAppBar(
          context,
          title: 'Cambiar contraseña',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: FutureBuilder(future: auth.getLoginInfo(), builder: (context, data) {

              if(!data.hasData || data.data == null) {
                return const CircularProgressIndicator(color: Colors.white);
              }

              return data.data!.fold((err) => const SizedBox.shrink(), (contact) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/password.png', width: 100),
                    const SizedBox(height: 32),
                    const GoogleTextWidget(
                      'Si deseas cambiar o recuperar tu contraseña, contáctanos al:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GoogleTextWidget(
                      'Whatsapp: ${contact.whatsapp}',
                      textAlign: TextAlign.center,
                    ),
                    GoogleTextWidget(
                      'Call Center: ${contact.fonosoporte}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              });

            })
          ),
        )
    );
  }
}
