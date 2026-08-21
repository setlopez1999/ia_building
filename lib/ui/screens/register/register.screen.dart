import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tvapp/config/extensions/context.extension.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/infraestructure/dtos/register_dto/register_user_dto.dart';
import 'package:tvapp/ui/providers/register/register_notifier.dart';
import 'package:tvapp/ui/screens/register/register-confirmation.screen.dart';
import 'package:tvapp/ui/screens/register/wigdets/location_data.register_from.widget.dart';
import 'package:tvapp/ui/screens/register/wigdets/personal_data.register_form.widget.dart';
import 'package:tvapp/ui/shared/widgets/app_bar.widget.dart';

/// Register Screen
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static String name = 'register';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  RegisterUserDto? _personalData;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerProvider, (_, next) {
      if (next is RegisterSuccess) {
        context.pushReplacementNamed(RegisterConfirmationScreen.name);
      } else if (next is RegisterError) {
        context.dialog(
          icon: Icon(Icons.dangerous, color: AppTheme.secondaryColor(context), size: 48),
          title: 'Error',
          content: next.error.message,
        );
      }
    });
    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Registro',
        leading: IconButton(
          onPressed: () {
            if (currentIndex == 0) {
              context.pop();
            } else {
              setState(() {
                currentIndex = 0;
              });
              _tabController.animateTo(0);
            }
          },
          icon: const Icon(Icons.arrow_back, size: 32),
          color: AppTheme.textColor(context),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          PersonalDataForm(
            personalData: _personalData,
            onNext: (personalData) {
              setState(() {
                currentIndex = 1;
                _personalData = personalData;
              });
              _tabController.animateTo(1);
            },
          ),
          LocationDataForm(
            onConfirm: ({
              String departmentCode = '',
              String provinceCode = '',
              String districtCode = '',
              bool acceptTerms = false,
              bool acceptPolicies = false,
            }) async {
              await ref.read(registerProvider.notifier).submit(
                personalData: _personalData!,
                departmentCode: departmentCode,
                provinceCode: provinceCode,
                districtCode: districtCode,
                acceptTerms: acceptTerms,
                acceptPolicies: acceptPolicies,
              );
            },
          ),
        ],
      ),
    );
  }
}
