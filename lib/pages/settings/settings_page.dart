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
    final simpleFlashcards = SimpleFlashcards.of(context);
    final navigator = Navigator.of(context);
    try {
      final picked = await FilePickerCross.importFromStorage(
        type: FileTypeCross.custom,
        fileExtension: 'csv',
      );
      final data = String.fromCharCodes(picked.toUint8List());
      simpleFlashcards.importFromCsv(
          picked.fileName ?? 'import ${DateTime.now().toIso8601String()}',
          data);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(L10n.of(context)!.oopsSomethingWentWrong),
      ));
      rethrow;
    }
    navigator.popUntil((route) => route.isFirst);
  }

  bool get canExport => SimpleFlashcards.of(context).stacks.isNotEmpty;

  void openWebsite() => launchUrl(Uri.parse(AppConstants.applicationWebsite));

  void openIssueSite() => launchUrl(Uri.parse(AppConstants.issueUrl));

  @override
  Widget build(BuildContext context) => SettingsPageView(this);
}
