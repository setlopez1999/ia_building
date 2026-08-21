import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/application/states/auth/auth_state.dart';
import 'package:tvapp/ui/providers/auth/auth_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});
  static String name = 'Plan';
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Perfil',
      ),
      body: auth.maybeWhen(orElse: () => const CircularProgressIndicator(color: Colors.white), success: (user) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Column(
              children: ListTile.divideTiles(
                color: Colors.white24,
                tiles: [
                  ListTile(
                    title: const GoogleTextWidget(
                      'Plan Asociado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: GoogleTextWidget(
                      user.plan ?? 'Plan Familiar',
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
      })
    );
  }
}
