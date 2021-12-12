import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:simple_flashcards/config/app_constants.dart';
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
    try {
      final picked = await FilePickerCross.importFromStorage(
        type: FileTypeCross.custom,
        fileExtension: 'json',
      );
      final data = String.fromCharCodes(picked.toUint8List());
      await SimpleFlashcards.of(context).importFromJson(jsonDecode(data));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(L10n.of(context)!.oopsSomethingWentWrong),
      ));
      rethrow;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  bool get canExport => SimpleFlashcards.of(context).stacks.isNotEmpty;

  void exportStacks() async {
    final file = await SimpleFlashcards.of(context).exportToFile();
    FilePickerCross(file).exportToStorage();
  }

  void openWebsite() => launch(AppConstants.applicationWebsite);

  void openIssueSite() => launch(AppConstants.issueUrl);

  @override
  Widget build(BuildContext context) => SettingsPageView(this);
}
