import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenshare/authentication/ui/blocs/authentication_bloc.dart';
import 'package:greenshare/authentication/ui/login_page.dart';
import 'package:greenshare/home/ui/home_page.dart';

class GreenShareRouter {

  static GoRouter router(BuildContext context) {
    final isAuthenticated = context.select((AuthenticationBloc authBloc) => authBloc.state.status == AuthenticationStatus.authenticated);
    final userUid = context.select((AuthenticationBloc authBloc) => authBloc.state.user.id);
    return GoRouter(
      initialLocation: isAuthenticated
          ? '/home/$userUid'
          : '/signin',
      routes: [
        GoRoute(
          path: '/home/:userId',
          builder: (context, state) => HomePage(userUid: state.pathParameters['userId']!),
        ),
        GoRoute(
          path: '/signin',
          builder: (context, state) => const LoginPage(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        // Unprotected routes
        if (state.fullPath == '/signin') {
          return null;
        }

        if (!isAuthenticated) {
          return '/signin';
        } else {
          return null;
        }
      },
    );
  }
}
