import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_constants.dart';

abstract class AppThemes {
  static const double radius = 12;
  static ThemeData get light => ThemeData(
        visualDensity: VisualDensity.standard,
        primaryColorDark: Colors.white,
        primaryColorLight: const Color(0xff121212),
        brightness: Brightness.light,
        primaryColor: AppConstants.primaryColor,
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: AppConstants.primaryColor,
              secondary: AppConstants.primaryColor,
              secondaryVariant: AppConstants.secondaryColor,
              surface: lighten(AppConstants.primaryColor, 0.535),
            ),
        backgroundColor: Colors.white,
        secondaryHeaderColor: Colors.blueGrey.shade50,
        scaffoldBackgroundColor: Colors.white,
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppConstants.primaryColor,
            onPrimary: Colors.white,
            elevation: 6,
            shadowColor: const Color(0x44000000),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: const EdgeInsets.all(12),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 6,
          shadowColor: const Color(0x44000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          clipBehavior: Clip.hardEdge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: lighten(AppConstants.primaryColor, .51),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 6,
          shadowColor: Color(0x44000000),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        visualDensity: VisualDensity.standard,
        primaryColorDark: const Color(0xff121212),
        primaryColorLight: Colors.white,
        primaryColor: AppConstants.primaryColor,
        errorColor: const Color(0xFFCF6679),
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: lighten(AppConstants.primaryColor, 0.33),
              secondary: lighten(AppConstants.primaryColor, 0.33),
              secondaryVariant: AppConstants.secondaryColor,
              surface: darken(AppConstants.primaryColor, 0.35),
            ),
        secondaryHeaderColor: Colors.blueGrey.shade900,
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          clipBehavior: Clip.hardEdge,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
          filled: true,
          fillColor: Colors.blueGrey.shade900,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: darken(AppConstants.primaryColor, .31),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppConstants.primaryColor,
            onPrimary: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: const EdgeInsets.all(12),
          ),
        ),
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        appBarTheme: const AppBarTheme(
          elevation: 6,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Color(0xff1D1D1D),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(),
        ),
      );

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
