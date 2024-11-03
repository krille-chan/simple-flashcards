import 'dart:async';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:simple_flashcards/config/app_constants.dart';
import 'package:simple_flashcards/config/settings_keys.dart';
import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/ai_session/ai_session_page_view.dart';

class AiSessionPage extends StatefulWidget {
  final String stackName;
  final List<FlashCard> flashCards;

  const AiSessionPage({
    required this.flashCards,
    required this.stackName,
    super.key,
  });

  @override
  AiSessionPageController createState() => AiSessionPageController();
}

class AiSessionPageController extends State<AiSessionPage> {
  bool botIsTyping = false;

  final List<Messages> messages = [];

  late final OpenAI openAI;

  final TextEditingController textEditingController = TextEditingController();

  Object? error;

  // ignore: unused_field
  Timer? _animationTimer;

  final ValueNotifier<int> animationTick = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
    _initOpenAI();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      animationTick.value = (animationTick.value + 1) % 4;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => generateAiMessage());
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  late final String? customSystemPrompt;

  void _initOpenAI() {
    final token = SimpleFlashcards.of(context)
        .preferences
        .getString(SettingsKeys.openAiApiKey);

    customSystemPrompt = SimpleFlashcards.of(context)
        .preferences
        .getString(SettingsKeys.customAiPrompt);
    openAI = OpenAI.instance.build(
      token: token,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
      enableLog: true,
    );
  }

  void generateAiMessage([String? prompt]) async {
    if (prompt != null && prompt.isEmpty) return;

    setState(() {
      error = null;
      botIsTyping = true;
      if (prompt != null) {
        messages.add(Messages(role: Role.user, content: prompt));
        textEditingController.clear();
      }
    });

    try {
      final response = await openAI.onChatCompletion(
        request: ChatCompleteText(
          messages: [
            Messages(
              role: Role.system,
              content: AppConstants.aiBotSystemPrompt,
            ),
            Messages(
              role: Role.system,
              content:
                  '# Flashcard stack:\n\n"${widget.stackName}"\n${widget.flashCards.map((card) => 'Front: "${card.front}" Back: "${card.back}" Hint: "${card.hint}"').join('\n')}',
            ),
            Messages(
              role: Role.system,
              content:
                  'Please talk in this language: "${L10n.of(context)!.localeName}"',
            ),
            if (customSystemPrompt != null)
              Messages(
                role: Role.system,
                content: customSystemPrompt,
              ),
            ...messages,
          ],
          model: GptTurboChatModel(),
          maxToken: null,
        ),
      );
      final botMessage = response?.choices.firstOrNull?.message?.content;
      if (botMessage == null) throw Exception('No response');

      setState(() {
        messages.add(
          Messages(
            role: Role.assistant,
            content: botMessage,
          ),
        );
      });
    } catch (e) {
      setState(() {
        error = e;
      });
    } finally {
      setState(() {
        botIsTyping = false;
      });
    }
  }

  void endSession(bool startNextSession) async {
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.markAllCardsAsLearned,
      okLabel: L10n.of(context)!.yes,
      cancelLabel: L10n.of(context)!.no,
    );
    if (consent == OkCancelResult.ok) {
      if (!mounted) return;
      final simpleFlashcards = SimpleFlashcards.of(context);
      for (final card in widget.flashCards) {
        if (!card.canLevelUp) continue;
        await simpleFlashcards.editCardLevel(
          widget.stackName,
          card.id,
          card.level + 1,
        );
      }
    }

    if (!mounted) return;
    Navigator.of(context).pop<bool>(startNextSession);
  }

  @override
  Widget build(BuildContext context) => AiSessionPageView(this);
}
