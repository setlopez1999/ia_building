import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/ui/shared/constants/app_assets.dart';
import 'package:tvapp/config/extensions/context.extension.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/core/providers/repository_providers.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/screens/change_password/change_password_screen.dart';
import 'package:tvapp/ui/screens/home/home.screen.dart';
import 'package:tvapp/ui/screens/main/main.screen.dart';
import 'package:tvapp/ui/screens/register/register.screen.dart';
import 'package:tvapp/ui/shared/widgets/global_text.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';
import 'package:tvapp/ui/shared/widgets/input_password.widget.dart';
import 'package:tvapp/ui/shared/widgets/input_text.widget.dart';

/// Body Widget
class BodyWidget extends ConsumerStatefulWidget {
  const BodyWidget({super.key});

  @override
  ConsumerState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<BodyWidget> {
  bool _obscureText = true;
  bool _loadingLogin = false;
  bool _checkRemember = false;

  final formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    ref.read(rememberRepositoryProvider).getRemember().then((str) {
      if(str == '') {
        return;
      }

      final splt = str.split(' __ ');
      final String ru = splt[0];
      final String rp = splt[1];

      setState(() {
        userController.text = ru;
        passController.text = rp;
        _checkRemember = true;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.logoOneplay,
                    width: MediaQuery.of(context).size.width *
                        Environment.splashWidth *
                        0.6,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              Column(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 48),
                        child: GlobalTextWidget(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputText(
                      userController: userController, hintText: 'Usuario'),
                  const SizedBox(height: 18),
                  InputPassword(
                    passController: passController,
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    obscureText: _obscureText,
                  ),

                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        _checkRemember = !_checkRemember;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const GoogleTextWidget('Recordar contraseña'),
                        const SizedBox(width: 8),
                        Checkbox(
                          value: _checkRemember,
                          checkColor: AppTheme.secondaryColor(context),
                          activeColor: Colors.white,

                          onChanged: _loadingLogin ? null : (checked) {
                            setState(() {
                              _checkRemember = checked ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(ChangePasswordScreen.name);
                    },
                    child: const GlobalTextWidget(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  if (Environment.registerEnabled)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const GlobalTextWidget('¿Aún no tienes cuenta?', style: TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(RegisterScreen.name);
                          },
                          child: const GlobalTextWidget(
                            'Regístrate',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(64),
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _loadingLogin
                          ? () {}
                          : () async {

                              setState(() {
                                _loadingLogin = true;
                              });
                              if (formKey.currentState!.validate()) {
                                await ref
                                    .read(authProvider.notifier)
                                    .login(userController.text,
                                        passController.text);

                                await ref.read(authProvider)
                                  .maybeWhen(
                                    error: (exception) {
                                      context.dialog(
                                        icon: Icon(
                                          Icons.dangerous,
                                          color: AppTheme.secondaryColor(context),
                                          size: 48,
                                        ),
                                        title: exception.identifier,
                                        content: exception.message,
                                      );
                                      setState(() {
                                        _loadingLogin = false;
                                      });
                                    },
                                    success: (user) async {

                                      if(_checkRemember) {
                                        await ref.read(rememberRepositoryProvider).setRemember(userController.text, passController.text);
                                      }
                                      else {
                                        await ref.read(rememberRepositoryProvider).cleanRemember();
                                      }

                                      await ref.read(authProvider.notifier).saveSession(userController.text);
                                      context.pushReplacementNamed(MainScreen.name);
                                    },
                                    orElse: () {},
                                  );
                              }
                              setState(() {
                                _loadingLogin = false;
                              });
                              return;
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: _loadingLogin
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
