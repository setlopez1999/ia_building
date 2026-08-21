import 'package:flutter/material.dart';
import 'package:tvapp/ui/screens/login/widgets/body.login.widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static String name = 'login';

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Scaffold(
      body: BodyWidget(),
    );
  }
}
