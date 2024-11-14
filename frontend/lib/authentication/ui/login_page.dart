import 'package:flutter/material.dart';
import 'package:greenshare/authentication/repositories/authentication_repository.dart';
import 'package:greenshare/common/config/injectable.dart';

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
    return const Scaffold(
      body: SafeArea(
        child: Placeholder(),
      ),
    );
  }
}
