import 'package:flutter/material.dart';
import 'package:supercontext/supercontext.dart';
import 'package:tvapp/ui/shared/widgets/google_text_span.widget.dart';

class InputText extends StatelessWidget {
  final TextEditingController userController;
  final String? hintText;

  const InputText({
    super.key,
    required this.userController,
    this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: googleStyle(context),
      controller: userController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value.isNotNull && value!.isEmpty) {
          return 'Este campo es requerido.';
        }
        return null;
      },
    );
  }
}
