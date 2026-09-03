import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supercontext/supercontext.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/core/infraestructure/dtos/register_dto/register_user_dto.dart';
import 'package:tvapp/ui/shared/widgets/app_input.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

/// Widget Personal Data Form For Register
class PersonalDataForm extends ConsumerStatefulWidget {
  const PersonalDataForm({super.key, required this.onNext, this.personalData});

  final ValueChanged<RegisterUserDto>? onNext;
  final RegisterUserDto? personalData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalDataFormState();
}

class _PersonalDataFormState extends ConsumerState<PersonalDataForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    if (widget.personalData.isNotNull) {
      final formUserValues = widget.personalData;
      _firstNameController.text = formUserValues!.firstName;
      _lastNameController.text = formUserValues.lastName;
      _dniNumberController.text = formUserValues.dni;
      _phoneNumberController.text = formUserValues.phoneNumber;
      _emailController.text = formUserValues.email;
    }
    super.initState();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final onNext = widget.onNext;
    if (onNext == null) return;
    onNext(
      RegisterUserDto(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dni: _dniNumberController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Sin scroll el teclado tapa los campos de abajo. El bloque de
            // campos scrollea y el boton queda anclado al pie.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            GoogleTextWidget(
                              'Datos personales',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: Environment.h1FSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        AppInput(
                          controller: _firstNameController,
                          textInputAction: TextInputAction.next,
                          hint: 'Nombre',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es requerido.';
                            } else if (value.length < 3) {
                              return 'El nombre debe tener al menos 3 caracteres.';
                            }
                            return null;
                          },
                        ),
                        AppInput(
                          controller: _lastNameController,
                          textInputAction: TextInputAction.next,
                          hint: 'Apellidos',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es requerido.';
                            } else if (!RegExp(r'^\S+\s+\S+').hasMatch(value)) {
                              return 'Debe colocar sus dos apellidos.';
                            }
                            return null;
                          },
                        ),
                        AppInput(
                          controller: _dniNumberController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          hint: 'DNI*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es requerido.';
                            } else if (value.length != 8) {
                              return 'Ingrese un DNI de 8 dígitos.';
                            }
                            return null;
                          },
                        ),
                        AppInput(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          hint: 'Celular',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es requerido.';
                            } else if (value.length < 9) {
                              return 'Ingrese un número de 9 dígitos.';
                            } else if (!value.startsWith('9')) {
                              return 'El número de celular debe comenzar con 9.';
                            }
                            return null;
                          },
                        ),
                        AppInput(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          hint: 'Correo electrónico',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es requerido.';
                            }
                            final emailRegExp = RegExp(
                                r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                            if (!emailRegExp.hasMatch(value)) {
                              return 'Ingrese un correo electrónico válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Environment.actionColor,
                minimumSize: const Size.fromHeight(64),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _submit,
              child:
                  const Text('Siguiente', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
