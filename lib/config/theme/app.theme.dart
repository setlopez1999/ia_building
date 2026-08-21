import 'package:flutter/material.dart';
import 'package:tvapp/config/environment/environment.dart';

/// App Theme
class AppTheme {
  AppTheme._();

  static Color primaryColor(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Environment.darkThemeColor
        : Environment.lightThemeColor;
  }

  static Color secondaryColor(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Environment.secondaryDarkThemeColor
        : Environment.secondaryLightThemeColor;
  }

  static Color textColor(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Environment.darkThemeColorText
        : Environment.lightThemeColorText;
  }

  static Color secondaryTextColor(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Environment.secondaryDarkThemeTextColor
        : Environment.secondaryLightThemeTextColor;
  }
}
