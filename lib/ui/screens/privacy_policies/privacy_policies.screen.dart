import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/ui/providers/settings/settings_provider.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

/// Privacy Policies
class PrivacyPolicies extends ConsumerStatefulWidget {
  const PrivacyPolicies({super.key});

  static String name = 'Privacy Policies';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrivacyPoliciesState();
}

class _PrivacyPoliciesState extends ConsumerState<PrivacyPolicies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Políticas de privacidad',
      ),
      body: ref.watch(settingsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (settings) => Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Html(
                data: settings.policies,
                style: {'body': Style(color: AppTheme.textColor(context))},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
