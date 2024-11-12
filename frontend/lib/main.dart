import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/home/ui/home_page.dart';
import 'package:greenshare/theme.dart';
import 'package:injectable/injectable.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    configureDependencies(Environment.dev);
  } else {
    configureDependencies(Environment.prod);
  }

  runApp(const GreenShareApp());
}

class GreenShareApp extends StatefulWidget {
  const GreenShareApp({super.key});

  @override
  State<GreenShareApp> createState() => _GreenShareAppState();
}

class _GreenShareAppState extends State<GreenShareApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenShare',
      theme: kTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
