import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_constants.dart';

ThemeData buildTheme(ColorScheme? scheme, bool isLight) => ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              isLight ? Brightness.dark : Brightness.light,
          statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
          statusBarBrightness: !isLight ? Brightness.dark : Brightness.light,
        ),
      ),
      colorSchemeSeed: scheme?.primary ?? AppConstants.primaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
