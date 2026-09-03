import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/extensions/context.extension.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/content/content_state.dart';
import 'package:tvapp/core/theme/app_colors.dart';
import 'package:tvapp/ui/providers/register/departments_provider.dart';
import 'package:tvapp/ui/providers/register/districts_provider.dart';
import 'package:tvapp/ui/providers/register/provinces_provider.dart';
import 'package:tvapp/ui/screens/privacy_policies/privacy_policies.screen.dart';
import 'package:tvapp/ui/screens/terms_and_conditions/terms_and_conditions.screen.dart';
import 'package:tvapp/ui/shared/widgets/api_state.widget.dart';
import 'package:tvapp/ui/shared/widgets/app_input.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text_span.widget.dart';

/// Widget Location Data Form For Register
class LocationDataForm extends ConsumerStatefulWidget {
  const LocationDataForm({
    super.key,
    required this.onConfirm,
  });

  final Future<void> Function({
    required String departmentCode,
    required String provinceCode,
    required String districtCode,
    required bool acceptTerms,
    required bool acceptPolicies,
  }) onConfirm;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocationDataFormState();
}

class _LocationDataFormState extends ConsumerState<LocationDataForm> {
  String departmentCode = '';
  String provinceCode = '';
  String districtCode = '';
  bool acceptedTermsAndPolicies = false;
  bool acceptedMarketing = false;
  bool loadingRegister = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final departmentsState = ref.watch(departmentsProvider);
    final provincesState = ref.watch(provincesProvider);
    final districtsState = ref.watch(districtsProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Sin scroll el teclado tapa el contenido de abajo. El bloque
            // scrollea y el boton queda anclado al pie.
            Expanded(
                child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      const Row(
                        children: [
                          GoogleTextWidget(
                            'Ubicación',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      departmentsState.maybeWhen(
                        success: (departments) {
                          return DropdownButtonFormField(
                            decoration: AppInput.decoration(hint: 'Departamento'),
                            dropdownColor: AppColors.container,
                            items: List<DropdownMenuItem<String>>.from(
                              departments.map(
                                (department) {
                                  return DropdownMenuItem(
                                    value: department.code,
                                    child: GoogleTextWidget(
                                      department.description,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                departmentCode = value!;
                                provinceCode = '';
                                districtCode = '';
                              });
                              ref
                                  .read(provincesProvider.notifier)
                                  .change(value!);

                              // reset districts
                              ref.read(districtsProvider.notifier).reset();
                            },
                          );
                        },
                        // Regla 1: si la carga de departamentos falla el usuario
                        // tiene que enterarse. Antes caía en un SizedBox vacío
                        // y el campo simplemente desaparecía de la pantalla.
                        error: (failure) => ApiErrorView(
                          failure: failure,
                          onRetry: () => ref
                              .read(departmentsProvider.notifier)
                              .getDepartments(),
                        ),
                        orElse: () => const SizedBox(),
                        initial: () {
                          Future.microtask(() async {
                            await ref
                                .read(departmentsProvider.notifier)
                                .getDepartments();
                          });

                          // Regla 1: mientras pide los departamentos se ve que
                          // está cargando, no un hueco vacío.
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.textColor(context),
                            ),
                          );
                        },
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.textColor(context),
                          ),
                        ),
                      ),
                      provincesState.maybeWhen(
                        success: (provinces) {
                          if (provinces.isNotEmpty) {
                            return DropdownButtonFormField(
                              decoration: AppInput.decoration(hint: 'Provincia'),
                              dropdownColor: AppColors.container,
                              items: List<DropdownMenuItem<String>>.from(
                                provinces.map(
                                  (province) {
                                    return DropdownMenuItem(
                                      value: province.code,
                                      child: GoogleTextWidget(
                                        province.description,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  provinceCode = value!;
                                  districtCode = '';
                                });
                                ref
                                    .read(districtsProvider.notifier)
                                    .change(departmentCode, value!);
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.textColor(context),
                          ),
                        ),
                        orElse: () => const SizedBox(),
                      ),
                      districtsState.maybeWhen(
                        success: (districts) {
                          if (districts.isNotEmpty) {
                            return DropdownButtonFormField(
                              decoration: AppInput.decoration(hint: 'Distrito'),
                              dropdownColor: AppColors.container,
                              items: List<DropdownMenuItem<String>>.from(
                                districts.map(
                                  (district) {
                                    return DropdownMenuItem(
                                      value: district.code,
                                      child: GoogleTextWidget(
                                        district.description,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  districtCode = value!;
                                });
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                        orElse: SizedBox.new,
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.textColor(context),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              value: acceptedTermsAndPolicies,
                              onChanged: (value) {
                                setState(() {
                                  acceptedTermsAndPolicies = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 86,
                            child: RichText(
                              text: googleTextSpan(
                                context,
                                value: 'Al crear una cuenta aceptas tu '
                                    'conformidad a nuestos ',
                                style: const TextStyle(
                                  fontSize: 9,
                                ),
                                children: [
                                  googleTextSpan(
                                    context,
                                    value: 'Términos y Condiciones',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onTap: () {
                                      context.pushNamed(
                                        TermsAndConditions.name,
                                      );
                                    },
                                  ),
                                  googleTextSpan(
                                    context,
                                    value: ' y ',
                                  ),
                                  googleTextSpan(
                                    context,
                                    value: 'Políticas de privacidad.',
                                    onTap: () {
                                      context.pushNamed(
                                        PrivacyPolicies.name,
                                      );
                                    },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              value: acceptedMarketing,
                              onChanged: (value) {
                                setState(() {
                                  acceptedMarketing = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 86,
                            child: RichText(
                              text: googleTextSpan(
                                context,
                                value: 'Acepto recibir el envío exclusivo de '
                                    'actualizaciones y promociones especiales de '
                                    '${Environment.appName}',
                                style: const TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Environment.actionColor,
                disabledBackgroundColor: Colors.grey,
                minimumSize: const Size.fromHeight(64),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (!loadingRegister) {
                  if (departmentCode == '' ||
                      provinceCode == '' ||
                      districtCode == '') {
                    await context.dialog(
                        icon: Icon(
                          Icons.dangerous,
                          color: AppTheme.secondaryColor(context),
                          size: 48,
                        ),
                        title: 'Error',
                        content: 'Debe completar todos los campos');
                  } else {
                    if (!acceptedTermsAndPolicies) {
                      await context.dialog(
                          icon: Icon(
                            Icons.dangerous,
                            color: AppTheme.secondaryColor(context),
                            size: 48,
                          ),
                          title: 'Error',
                          content: 'Debe aceptar los términos y condiciones');
                    }
                    if (acceptedTermsAndPolicies) {
                      setState(() {
                        loadingRegister = true;
                      });
                      await widget.onConfirm(
                        departmentCode: departmentCode,
                        provinceCode: provinceCode,
                        districtCode: districtCode,
                        acceptTerms: acceptedTermsAndPolicies,
                        acceptPolicies: acceptedMarketing,
                      );
                      setState(() {
                        loadingRegister = false;
                      });
                    }
                  }
                  setState(() {
                    loadingRegister = false;
                  });
                }
              },
              child: loadingRegister
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Siguiente',
                      style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
