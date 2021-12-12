import 'package:flutter/material.dart';

abstract class AppConstants {
  static const String appName = 'Simple Flashcards';
  static const String dbName = 'simple_flashcards_stacks';
  static const String applicationWebsite =
      'https://gitlab.com/KrilleFear/simple-flashcards';
  static const double borderRadius = 12.0;
  static const String privacyUrl = '$applicationWebsite/-/blob/main/PRIVACY.md';
  static const String issueUrl = '$applicationWebsite/issues';
  static const Color primaryColor = Color(0xFF5625BA);
  static const Color primaryColorLight = Color(0xFFCCBDEA);
  static const Color secondaryColor = Color(0xFF41a2bc);
}
