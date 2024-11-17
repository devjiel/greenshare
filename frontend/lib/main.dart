import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenshare/authentication/ui/blocs/authentication_bloc.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/router.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    await configureDependencies(Environment.dev);
  } else {
    await configureDependencies(Environment.prod);
  }

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider.value(value: getIt<AuthenticationBloc>()..add(const AuthenticationSubscriptionRequested())),
      BlocProvider.value(value: getIt<UserBloc>()),
      BlocProvider.value(value: getIt<CarbonReductionBloc>()),
    ], child: const GreenShareApp()),
  );
}

class GreenShareApp extends StatefulWidget {
  const GreenShareApp({super.key});

  @override
  State<GreenShareApp> createState() => _GreenShareAppState();
}

class _GreenShareAppState extends State<GreenShareApp> {

  void _initialLoading(String userUid) {
    if (getIt<UserBloc>().state is UserStateInitial) {
      getIt<UserBloc>().add(StartListeningUser(userUid));
      getIt<CarbonReductionBloc>().add(LoadCarbonReductionEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthenticationBloc>().state.status == AuthenticationStatus.authenticated) {
      _initialLoading(context.read<AuthenticationBloc>().state.user.id);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserStateLoaded) {
              getIt<AvailableFilesCubit>().loadFiles(state.user.files);
            } else if (state is UserStateError) {
              context.read<AuthenticationBloc>().add(const AuthenticationLogoutRequested()); // TODO show an error ?
            }
          },
        ),
      ],
      child: MaterialApp.router(
        title: context.localization.appName,
        theme: kTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GreenShareRouter.router(context),
      ),
    );
  }
}
