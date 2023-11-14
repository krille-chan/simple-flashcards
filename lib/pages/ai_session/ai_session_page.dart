import 'dart:async';

import 'package:flutter/material.dart';

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

  void _initOpenAI() {
    final token = SimpleFlashcards.of(context)
        .preferences
        .getString(SettingsKeys.openAiApiKey);
    openAI = OpenAI.instance.build(
      token: token,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
      enableLog: true,
    );
  }

  void generateAiMessage([String? prompt]) async {
    if (prompt != null && prompt.isEmpty) return;

    setState(() {
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
                  'Flashcard stack: "${widget.stackName}"\n${widget.flashCards.map((card) => 'Front: "${card.front}" Back: "${card.back}"').join('\n')}',
            ),
            Messages(
              role: Role.system,
              content:
                  'Please talk in this language: "${L10n.of(context)!.localeName}"',
            ),
            ...messages,
          ],
          model: GptTurboChatModel(),
          temperature: 1.5,
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
        messages.add(
          Messages(
            role: Role.assistant,
            content: e.toString(),
          ),
        );
      });
      rethrow;
    } finally {
      setState(() {
        botIsTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AiSessionPageView(this);
}
