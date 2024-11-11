import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenshare/config/injectable.dart';
import 'package:greenshare/file_upload/ui/file_upload_section.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/ui/footer.dart';
import 'package:greenshare/ui/header.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Header(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: const FileUploadSection(),
            ),
            const Expanded(
              child: Footer(),
            ),
          ],
        ),
      ),
    );
  }
}