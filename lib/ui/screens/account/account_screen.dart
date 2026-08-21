import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/environment/environment.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/screens/change_password/change_password_screen.dart';
import 'package:tvapp/ui/screens/family_filter/family_filter_screen.dart';
import 'package:tvapp/ui/screens/login/login.screen.dart';
import 'package:tvapp/ui/screens/plan/plan_screen.dart';
import 'package:tvapp/ui/screens/profile/profile_screen.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class MyAccountScreen extends ConsumerStatefulWidget {
  const MyAccountScreen({super.key});

  @override
  ConsumerState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends ConsumerState<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Mi cuenta',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            spacing: 18,
            children: [
              ListTile(
                onTap: () {
                  context.pushNamed(ProfileScreen.name);
                },
                leading: const Icon(
                  Icons.account_box_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                title: GoogleTextWidget(
                  'Perfil',
                  style: TextStyle(
                    fontSize: Environment.h1FSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              /// Plan
              ListTile(
                onTap: () async {
                  await ref.read(authProvider.notifier).loadSession();
                  await context.pushNamed(PlanScreen.name);
                },
                leading: const Icon(
                  Icons.dvr_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                title: GoogleTextWidget(
                  'Mi Plan',
                  style: TextStyle(
                    fontSize: Environment.h1FSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              /// Change password
              ListTile(
                onTap: () {
                  context.pushNamed(ChangePasswordScreen.name);
                },
                leading: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                title: GoogleTextWidget(
                  'Cambiar contraseña',
                  style: TextStyle(
                    fontSize: Environment.h1FSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              /// Family Filter
              ListTile(
                onTap: () {
                  context.pushNamed(FamilyFilterScreen.name);
                },
                leading: const Icon(
                  Icons.supervisor_account_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                title: GoogleTextWidget(
                  'Control Parental',
                  style: TextStyle(
                    fontSize: Environment.h1FSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              /// Sign out
              ListTile(
                onTap: () async {
                  final result = await showModalBottomSheet<bool>(
                    context: context,
                    builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        color: AppTheme.textColor(context),
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GoogleTextWidget(
                              '¿Deseas cerrar sesión?',
                              style: TextStyle(
                                color: AppTheme.primaryColor(context),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 48),
                            Row(
                              children: [
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(86, 49),
                                  ),
                                  onPressed: () => context.pop(true),
                                  child: const Text('Sí', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 16),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: AppTheme.primaryColor(context)
                                          .withValues(alpha: 0.5),
                                      width: 2,
                                    ),
                                    minimumSize: const Size(86, 49),
                                  ),
                                  onPressed: () => context.pop(false),
                                  child: const Text('No'),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  if (result == true) {
                    await ref.read(authProvider.notifier).logout();
                  }
                },
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 32,
                ),
                title: GoogleTextWidget(
                  'Cerrar sesión',
                  style: TextStyle(
                    fontSize: Environment.h1FSize,
                    fontWeight: FontWeight.w500,
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
