import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/home/home_page.dart';
import 'package:simple_flashcards/utils/theme_data_builder.dart';

void main() async {
  final simpleFlashcards = await SimpleFlashcards.init();
  runApp(SimpleFlashcardsApp(simpleFlashcards));
}

class SimpleFlashcardsApp extends StatelessWidget {
  final SimpleFlashcards simpleFlashcards;
  const SimpleFlashcardsApp(this.simpleFlashcards, {super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (
      ColorScheme? lightDynamic,
      ColorScheme? darkDynamic,
    ) {
      return MaterialApp(
        title: AppConstants.appName,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
        theme: buildTheme(lightDynamic, true),
        darkTheme: buildTheme(darkDynamic, false),
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        builder: simpleFlashcards.builder,
      );
    });
  }
}
