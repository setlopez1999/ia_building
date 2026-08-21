
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/providers/settings/settings_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

/// Terms and conditions
class TermsAndConditions extends ConsumerStatefulWidget {
  const TermsAndConditions({super.key});

  static String name = 'Terms & Conditions';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsAndConditionsState();
}

class _TermsAndConditionsState extends ConsumerState<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Términos y condiciones',
      ),
      body: ref.watch(settingsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (settings) => Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Html(
                data: settings.terms,
                style: {'body': Style(color: AppTheme.textColor(context))},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
