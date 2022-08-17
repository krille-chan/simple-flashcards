import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_constants.dart';

ThemeData buildTheme(ColorScheme? scheme, bool isLight) => ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
          statusBarBrightness: !isLight ? Brightness.dark : Brightness.light,
        ),
      ),
      colorSchemeSeed: scheme == null ? AppConstants.primaryColor : null,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(64)),
      ),
    );
