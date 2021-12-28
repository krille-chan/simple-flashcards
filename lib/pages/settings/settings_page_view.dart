import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/pages/settings/settings_page.dart';
import 'package:yaru_icons/yaru_icons.dart';

class SettingsPageView extends StatelessWidget {
  final SettingsPageController controller;
  const SettingsPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.settings)),
      body: ListView(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 128,
              height: 128,
            ),
          )),
          const Divider(height: 1),
          if (controller.canExport)
            ListTile(
              leading: const Icon(YaruIcons.share),
              title: Text(L10n.of(context)!.exportStacks),
              onTap: controller.exportStacks,
            ),
          ListTile(
            leading: const Icon(YaruIcons.download),
            title: Text(L10n.of(context)!.importStacks),
            onTap: controller.importStacks,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(YaruIcons.desktop_remote),
            title: Text(L10n.of(context)!.website),
            onTap: controller.openWebsite,
          ),
          ListTile(
            leading: const Icon(YaruIcons.question),
            title: Text(L10n.of(context)!.help),
            onTap: controller.openIssueSite,
          ),
          ListTile(
            leading: const Icon(YaruIcons.information),
            title: Text(L10n.of(context)!.about),
            onTap: controller.aboutAction,
          ),
        ],
      ),
    );
  }
}
