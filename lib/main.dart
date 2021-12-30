import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:yaru/yaru.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/home/home_page.dart';

void main() async {
  final simpleFlashcards = await SimpleFlashcards.init();
  runApp(SimpleFlashcardsApp(simpleFlashcards));
}

class SimpleFlashcardsApp extends StatelessWidget {
  final SimpleFlashcards simpleFlashcards;
  const SimpleFlashcardsApp(this.simpleFlashcards, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      home: const HomePage(),
      theme: yaruLight,
      darkTheme: yaruDark,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      builder: simpleFlashcards.builder,
    );
  }
}
