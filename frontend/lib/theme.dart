import 'package:flutter/material.dart';

const kLightGreen = Color(0xFFD8E4D6);
const kDarkGreen = Color(0xFF5A6558);
const kBlack = Color(0xFF141514);
const kWhite = Color(0xFFFFFFFF);

const kDefaultPadding = 24.0;
const kSmallPadding = 12.0;

final kTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Poppins",
  primaryColor: kLightGreen,
  disabledColor: kDarkGreen,
  scaffoldBackgroundColor: kBlack,
  textTheme: kTextTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: kButtonStyle,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(primary: kLightGreen, secondary: kDarkGreen),
  useMaterial3: true,
);

const kBaseTextStyle = TextStyle(
  color: kLightGreen,
  fontFamily: "Poppins",
  height: 1.3,
);

final kTextTheme = TextTheme(
  titleLarge: kBaseTextStyle.copyWith(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  ),
  titleMedium: kBaseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
  titleSmall: kBaseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
  bodyLarge: kBaseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ),
  bodyMedium: kBaseTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  ),
  bodySmall: kBaseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  ),
);

const kTitleText = TextStyle(
  color: kWhite,
  fontSize: 38.0,
  fontWeight: FontWeight.w900,
);

const kBodyText = TextStyle(
  color: kWhite,
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

final kButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(kLightGreen),
  textStyle: WidgetStatePropertyAll(kTextTheme.bodyLarge?.copyWith(color: kBlack),),
  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  elevation: const WidgetStatePropertyAll(6),
  minimumSize: const WidgetStatePropertyAll(Size(350, 50)),
);

extension BuildContextHelper on BuildContext {
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
}