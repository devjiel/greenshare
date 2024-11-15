import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenshare/authentication/ui/blocs/authentication_bloc.dart';
import 'package:greenshare/authentication/ui/login_page.dart';
import 'package:greenshare/home/ui/home_page.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';

class GreenShareRouter {
  static GoRouter router(BuildContext context) {
    final isAuthenticated = context.select((AuthenticationBloc authBloc) => authBloc.state.status == AuthenticationStatus.authenticated);
    return GoRouter(
      initialLocation: isAuthenticated ? '/home' : '/signin',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        // Unprotected routes
        if (state.fullPath == '/login') {
          return null;
        }

        if (!isAuthenticated) {
          return '/login';
        }
        if (context.read<UserBloc>().state is UserStateLoaded) {
          return '/home';
        } else {
          return null;
        }
      },
    );
  }
}
