import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/settings_keys.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/settings/settings_page.dart';

class SettingsPageView extends StatelessWidget {
  final SettingsPageController controller;
  const SettingsPageView(this.controller, {super.key});

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
          ListTile(
            leading: const Icon(Icons.numbers_outlined),
            title: Text(L10n.of(context)!.cardsPerSession),
            subtitle: Text((SimpleFlashcards.of(context)
                        .preferences
                        .getInt(SettingsKeys.cardsPerSessionKey) ??
                    SettingsKeys.defaultCardsPerSessionKey)
                .toString()),
            onTap: controller.setCardsPerSession,
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(L10n.of(context)!.textToSpeechLanguage),
            subtitle: Text(controller.textToSpeechlanguage),
            onTap: controller.setTextToSpeechLanguage,
          ),
          SwitchListTile.adaptive(
            value: controller.isTextToSpeechEnabled,
            onChanged: controller.setTextToSpeech,
            title: Text(L10n.of(context)!.readOutLoudFront),
            controlAffinity: ListTileControlAffinity.trailing,
            secondary: const Icon(Icons.volume_up_outlined),
          ),
          SwitchListTile.adaptive(
            value: controller.typeAnswer,
            onChanged: controller.setTypeAnswer,
            title: Text(L10n.of(context)!.typeAnswer),
            controlAffinity: ListTileControlAffinity.trailing,
            secondary: const Icon(Icons.keyboard_alt_outlined),
          ),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.smart_toy_outlined),
            title: Text(L10n.of(context)!.enableAiChatLearning),
            onChanged: (enable) => controller.setopenAiApiKey(enable),
            controlAffinity: ListTileControlAffinity.trailing,
            value: controller.openAiApiKeyEnabled,
          ),
          if (controller.openAiApiKeyEnabled)
            ListTile(
              leading: const Icon(Icons.keyboard_outlined),
              title: Text(L10n.of(context)!.customAiPrompt),
              onTap: controller.setCustomAiPrompt,
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(L10n.of(context)!.importStacks),
            onTap: controller.importStacks,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.web_outlined),
            title: Text(L10n.of(context)!.website),
            onTap: controller.openWebsite,
          ),
          ListTile(
            leading: const Icon(Icons.help_outlined),
            title: Text(L10n.of(context)!.help),
            onTap: controller.openIssueSite,
          ),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: Text(L10n.of(context)!.about),
            onTap: controller.aboutAction,
          ),
        ],
      ),
    );
  }
}
