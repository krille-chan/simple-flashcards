import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:package_info/package_info.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'package:simple_flashcards/config/settings_keys.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/settings/settings_page_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageController createState() => SettingsPageController();
}

class SettingsPageController extends State<SettingsPage> {
  void aboutAction() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationIcon: Image.asset(
        'assets/images/logo.png',
        width: 56,
        height: 56,
      ),
      applicationVersion: packageInfo.version,
    );
  }

  void importStacks() async {
    final simpleFlashcards = SimpleFlashcards.of(context);
    final navigator = Navigator.of(context);
    final l10n = L10n.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
      if (picked == null || picked.files.isEmpty) return;
      final data = utf8.decode(
        picked.files.first.bytes!,
        allowMalformed: true,
      );
      simpleFlashcards.importFromCsv(
        picked.files.first.name.split('.').first,
        data,
      );
    } catch (_) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(l10n.oopsSomethingWentWrong),
      ));
      rethrow;
    }
    navigator.popUntil((route) => route.isFirst);
  }

  bool get canExport => SimpleFlashcards.of(context).stacks.isNotEmpty;

  void openWebsite() => launchUrl(Uri.parse(AppConstants.applicationWebsite));

  void openIssueSite() => launchUrl(Uri.parse(AppConstants.issueUrl));

  void setTextToSpeech(bool enable) async {
    await SimpleFlashcards.of(context)
        .preferences
        .setBool(SettingsKeys.enableTextToSpeechKey, enable);
    setState(() {});
  }

  bool get isTextToSpeechEnabled =>
      SimpleFlashcards.of(context)
          .preferences
          .getBool(SettingsKeys.enableTextToSpeechKey) ??
      false;

  String get textToSpeechlanguage =>
      SimpleFlashcards.of(context)
          .preferences
          .getString(SettingsKeys.textToSpeechLanguageKey) ??
      'en-US';

  void setTextToSpeechLanguage() async {
    final l10n = L10n.of(context)!;
    final preferences = SimpleFlashcards.of(context).preferences;
    final tts = TextToSpeech();
    final languages = await TextToSpeech().getDisplayLanguages() ?? [];
    if (!mounted) return;
    final newLanguage = await showConfirmationDialog(
      context: context,
      title: l10n.textToSpeechLanguage,
      actions: languages
          .map(
            (lang) => AlertDialogAction(
              key: lang,
              label: lang,
            ),
          )
          .toList(),
    );
    if (newLanguage == null) return;
    final newCode = await tts.getLanguageCodeByName(newLanguage);
    if (newCode == null) return;
    await preferences.setString(
      SettingsKeys.textToSpeechLanguageKey,
      newCode,
    );
    setState(() {});
  }

  void setCardsPerSession() async {
    final l10n = L10n.of(context)!;
    final preferences = SimpleFlashcards.of(context).preferences;
    final value = await showTextInputDialog(
      context: context,
      textFields: [
        DialogTextField(
          validator: (v) {
            if (v == null) return null;
            final i = int.tryParse(v);
            if (i != null && i > 0) return null;

            return 'Please enter a number over 0';
          },
          hintText: l10n.cardsPerSession,
          initialText: (preferences.getInt(SettingsKeys.cardsPerSessionKey) ??
                  SettingsKeys.defaultCardsPerSessionKey)
              .toString(),
        )
      ],
    );
    if (value == null) return;
    await preferences.setInt(
        SettingsKeys.cardsPerSessionKey, int.parse(value.single));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SettingsPageView(this);
}
