import 'package:flutter/material.dart';

abstract class AppConstants {
  static const String appName = 'Simple Flashcards';
  static const String dbName = 'simple_flashcards_stacks';
  static const String applicationWebsite =
      'https://gitlab.com/KrilleFear/simple-flashcards';
  static const double borderRadius = 12.0;
  static const String privacyUrl = '$applicationWebsite/-/blob/main/PRIVACY.md';
  static const String issueUrl = '$applicationWebsite/issues';
  static const Color primaryColor = Colors.blueAccent;
}
