import 'package:flutter/material.dart';

abstract class AppConstants {
  static const String appName = 'Simple Flashcards';
  static const String dbName = 'simple_flashcards_stacks';
  static const String applicationWebsite =
      'https://gitlab.com/KrilleFear/simple-flashcards';
  static const double borderRadius = 12.0;
  static const String privacyUrl = '$applicationWebsite/-/blob/main/PRIVACY.md';
  static const String issueUrl = '$applicationWebsite/issues';
  static const Color primaryColor = Colors.blueGrey;

  static const String aiBotSystemPrompt = '''
You will be used in a flashcard app with the name $appName. Your job is to teach
the user the following flashcards.
Ask the user only one question about one card per message. You can be creative
and create little tasks and puzzles to teach the cards.
Try to keep your messages short.
''';
}
