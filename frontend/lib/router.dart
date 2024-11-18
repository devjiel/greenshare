import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenshare/authentication/ui/blocs/authentication/authentication_bloc.dart';
import 'package:greenshare/authentication/ui/login_page.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/home/ui/home_page.dart';
import 'package:greenshare/share/ui/bloc/current_share/current_share_cubit.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';
import 'package:greenshare/share/ui/share_page.dart';
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
        GoRoute(
          path: '/share/:shareLinkUid',
          builder: (context, state) => BlocProvider.value(
            value: getIt<ShareLinksBloc>()..add(GetShareLinkFiles(state.pathParameters['shareLinkUid']!)),
            child: SharePage(shareLinkUid: state.pathParameters['shareLinkUid']!),
          ),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        // Unprotected routes
        if (state.fullPath == '/login' || state.fullPath == '/share/:shareLinkUid') {
          return null;
        }

        if (!isAuthenticated) {
          if (state.fullPath == '/share/:shareLinkUid') {
            getIt<CurrentShareCubit>().storeShareLink(state.pathParameters['shareLinkUid']!);
          }
          return '/login';
        }

        if (context.read<UserBloc>().state is UserStateLoaded) {
          final currentShare = context.read<CurrentShareCubit>().state;
          return currentShare ?? '/home';
        } else {
          return null;
        }
      },
    );
  }
}
