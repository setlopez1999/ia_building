import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/support_contact.widget.dart';

class ChangePasswordScreen extends ConsumerWidget {
  const ChangePasswordScreen({super.key});

  static String name = 'Change password';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Cambiar contraseña',
      ),
      body: const SupportContactBody(
        iconAsset: 'assets/icons/password.png',
        message: 'Si deseas cambiar o recuperar tu contraseña, contáctanos al:',
      ),
    );
  }
}
