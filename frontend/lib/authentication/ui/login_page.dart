import 'package:flutter/material.dart';
import 'package:greenshare/authentication/repositories/authentication_repository.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // TODO remove
  static const kDefaultEmail = 'test@mail.fr';
  static const kDefaultPassword = 'password';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: context.localization.email,
                  ),
                ),
                const SizedBox(
                  height: kSmallPadding,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: context.localization.password,
                  ),
                ),
                const SizedBox(
                  height: kSmallPadding,
                ),
                ElevatedButton(
                  onPressed: () {
                    getIt<AuthenticationRepository>().loginWithEmailAndPassword(
                      email: (_emailController.text.isNotEmpty) ? _emailController.text : kDefaultEmail,
                      password: (_passwordController.text.isNotEmpty) ? _emailController.text : kDefaultPassword,
                    );
                  },
                  child: Text(context.localization.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
