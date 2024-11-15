import 'package:flutter/material.dart';
import 'package:greenshare/authentication/repositories/authentication_repository.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/common/ui/widgets/loading_widget.dart';
import 'package:greenshare/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
        const Duration(seconds: 3), () => getIt<AuthenticationRepository>().loginWithEmailAndPassword(email: 'test@mail.fr', password: 'password'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LoadingWidget(),
              const SizedBox(width: kMaxPadding),
              Text(
                'Logging in...',
                style: context.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
