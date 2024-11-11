import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:greenshare/theme.dart';

final locales = ['en', 'fr'];

extension WidgetTesterExtension on WidgetTester {

  Future<void> pumpWidgetInDesktopMode({required Widget widget, String? locale}) async {
    view.physicalSize = const Size(1920, 1080);
    view.devicePixelRatio = 1.0;
    view.platformDispatcher.textScaleFactorTestValue = 1.0;

    await pumpWidgetWithLocale(widget, locale ?? 'en');
  }

  Future<void> pumpWidgetInPhoneMode({required Widget widget, String? locale}) async {
    view.physicalSize = const Size(500, 900);
    view.devicePixelRatio = 1.0;
    view.platformDispatcher.textScaleFactorTestValue = 0.5;

    await pumpWidgetWithLocale(widget, locale ?? 'en');
  }

  Future<void> pumpWidgetWithLocale(Widget widget, String locale) async {
    await pumpWidget(
      MaterialApp(
        theme: kTheme,
        home: Scaffold(body: widget),
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

Future<void> loadFonts() async {
  final poppinsFont = rootBundle.load('assets/fonts/Poppins-bold.ttf');
  FontLoader('Poppins')
    ..addFont(poppinsFont)
    ..load();
}

void ignoreOverflowErrors(
  FlutterErrorDetails details, {
  bool forceReport = false,
}) {
  bool ifIsOverflowError = false;
  bool isUnableToLoadAsset = false;

  // Detect overflow error.
  var exception = details.exception;
  if (exception is FlutterError) {
    ifIsOverflowError = !exception.diagnostics.any(
      (e) => e.value.toString().startsWith("A RenderFlex overflowed by"),
    );
    isUnableToLoadAsset = !exception.diagnostics.any(
      (e) => e.value.toString().startsWith("Unable to load asset"),
    );
  }

  // Ignore if is overflow error.
  if (ifIsOverflowError || isUnableToLoadAsset) {
    debugPrint('Ignored Error');
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  }
}
