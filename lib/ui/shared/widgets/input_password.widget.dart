import 'package:flutter/material.dart';
import 'package:supercontext/supercontext.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/ui/shared/widgets/google_text_span.widget.dart';

class InputPassword extends StatelessWidget {
  final TextEditingController passController;
  final VoidCallback onTap;
  final bool obscureText;

  const InputPassword({
    super.key,
    required this.passController,
    required this.onTap,
    this.obscureText = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: googleStyle(context),
      controller: passController,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        constraints: const BoxConstraints(
          maxHeight: 68,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: IconButton(
            onPressed: onTap,
            iconSize: 36,
            icon: Icon(
              obscureText
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
            color: Environment.inputHintColor.withOpacity(0.5),
          ),
        ),
      ),
      validator: (value) {
        if (value.isNull || value!.isEmpty) {
          return 'La contraseña no puede estar vacía';
          // } else if (value.length < 8) {
          //   return 'La contraseña debe tener al menos 8 caracteres';
          //   } else if (!RegExp('[A-Z]').hasMatch(value)) {
          //     return 'La contraseña debe tener al menos una letra mayúscula';
          // } else if (!RegExp('[a-z]').hasMatch(value)) {
          //   return 'La contraseña debe tener al menos una letra minúscula';
          // } else if (!RegExp('[0-9]').hasMatch(value)) {
          //   return 'La contraseña debe tener al menos un número';
          //   } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
          //     return r'La contraseña debe tener al menos un carácter especial (!@#$&*~)';
        }
        return null;
      },
      obscureText: obscureText,
    );
  }
}
