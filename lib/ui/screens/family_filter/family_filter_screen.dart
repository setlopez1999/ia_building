import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/support_contact.widget.dart';

class FamilyFilterScreen extends ConsumerWidget {
  const FamilyFilterScreen({super.key});

  static String name = 'family-filter';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Control Parental',
      ),
      body: const SupportContactBody(
        iconAsset: 'assets/icons/parental.png',
        message:
            'Si deseas cambiar o recuperar tu código Control Parental, contáctanos al:',
      ),
    );
  }
}
