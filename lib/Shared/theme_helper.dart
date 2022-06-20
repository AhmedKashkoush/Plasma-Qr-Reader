
import 'package:flutter/material.dart';
import 'package:plasma_qr_reader/Constants/app_constants.dart';

class ThemeHelper{
  static ThemeMode themeMode = ThemeMode.system;
  static ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    highlightColor: Colors.transparent,
    splashFactory: InkRipple.splashFactory,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    primaryColor: primaryColor,
    iconTheme: const IconThemeData(color: iconColor),
    useMaterial3: true,
    pageTransitionsTheme: _pageTransitionTheme,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: primaryColor,
      primarySwatch: primarySwatch,
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    highlightColor: Colors.transparent,
    splashFactory: InkRipple.splashFactory,
    scaffoldBackgroundColor: scaffoldDarkBackgroundColor,
    primaryColor: primaryColor,
    useMaterial3: true,
    iconTheme: const IconThemeData(color: iconDarkColor),
    pageTransitionsTheme: _pageTransitionTheme,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: primaryColor,
      primarySwatch: primarySwatch,
      brightness: Brightness.dark,
    ),
  );

  // static Future<void> loadTheme() async{
  //   final String _themeMode = await SharedPreferencesApi.getString('theme')?? 'system';
  //   switch (_themeMode){
  //     case 'light': themeMode = ThemeMode.light;break;
  //     case 'dark': themeMode = ThemeMode.dark;break;
  //     default: themeMode = ThemeMode.system;
  //   }
  // }

  static const PageTransitionsTheme _pageTransitionTheme = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      }
  );
}