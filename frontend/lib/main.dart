import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenshare/authentication/ui/blocs/authentication_bloc.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/router.dart';
import 'package:greenshare/theme.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    await configureDependencies(Environment.dev);
  } else {
    await configureDependencies(Environment.prod);
  }

  runApp(
    BlocProvider.value(
      value: getIt<AuthenticationBloc>()..add(const AuthenticationSubscriptionRequested()),
      child: const GreenShareApp(),
    ),
  );
}

class GreenShareApp extends StatefulWidget {
  const GreenShareApp({super.key});

  @override
  State<GreenShareApp> createState() => _GreenShareAppState();
}

class _GreenShareAppState extends State<GreenShareApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GreenShare',
      theme: kTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GreenShareRouter.router(context),
    );
  }
}
