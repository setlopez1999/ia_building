import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static String name = 'Profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.read(authProvider.notifier).getAllUserInfo();

    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Perfil',
      ),
      body: FutureBuilder(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.secondaryColor(context)),
            );
          } else {

            final (user, sensible) = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: ListTile.divideTiles(
                    color: Colors.transparent,
                    tiles: [
                      ListTile(
                        title: const GoogleTextWidget(
                          'Usuario',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: GoogleTextWidget(
                          user.usuario,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const GoogleTextWidget(
                          'Correo electrónico',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: GoogleTextWidget(
                          sensible.email,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ).toList(),
                ),
              ),
            );
          }
        },
      )
    );
  }
}
